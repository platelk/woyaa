package userstore

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"

	"github.com/platelk/woyaa/backend/domain"
)

type RedisCache struct {
	store  UserStorer
	client *redis.Client
}

func NewRedisCache(store UserStorer) *RedisCache {
	return &RedisCache{
		store: store,
		client: redis.NewClient(&redis.Options{
			Addr:     "localhost:6379",
			Password: "", // no password set
			DB:       0,  // use default DB
		}),
	}
}

func (r *RedisCache) WarmUp(c context.Context) error {
	users, err := r.store.GetAllUsers(c)
	if err != nil {
		return fmt.Errorf("can't warm up cache: %w", err)
	}
	for _, user := range users {
		_ = r.cacheUser(c, &user)
	}
	return nil
}

func (r *RedisCache) GetByID(c context.Context, id domain.UserID) (*domain.User, error) {
	usr, err := r.getFromCache(c, id)
	if err == nil {
		return usr, nil
	}
	user, err := r.store.GetByID(c, id)
	if err != nil {
		return nil, fmt.Errorf("can't retrieve user from underlying store")
	}
	go func() {
		_ = r.cacheUser(context.Background(), user)
	}()
	return user, nil
}

func (r *RedisCache) getFromCache(c context.Context, id domain.UserID) (*domain.User, error) {
	val, err := r.client.Get(c, id.String()).Result()
	if err != nil {
		return nil, fmt.Errorf("can't get from redis: %w", err)
	}
	return userFromJSON(val)
}

func (r *RedisCache) cacheUser(c context.Context, user *domain.User) error {
	data, err := json.Marshal(user)
	if err != nil {
		return fmt.Errorf("can't marshal user: %w", err)
	}
	_, err = r.client.Set(c, user.ID.String(), string(data), time.Hour).Result()
	if err != nil {
		return fmt.Errorf("can't store user on redis")
	}
	return nil
}

func (r *RedisCache) GetAllUsers(c context.Context) (domain.Users, error) {
	iter := r.client.Scan(c, 0, "*", 0).Iterator()
	var users domain.Users
	for iter.Next(c) {
		user, err := userFromJSON(iter.Val())
		if err != nil {
			continue
		}
		users = append(users, *user)
	}
	if err := iter.Err(); err != nil {
		return nil, fmt.Errorf("can't iterate on redis user: %w", err)
	}
	return users, nil
}

func userFromJSON(val string) (*domain.User, error) {
	var usr domain.User
	err := json.Unmarshal([]byte(val), &usr)
	if err != nil {
		return nil, fmt.Errorf("can't unmarshal user from redis: %w", err)
	}
	return &usr, nil
}
