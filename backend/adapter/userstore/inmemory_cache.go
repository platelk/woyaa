package userstore

import (
	"context"
	"fmt"

	cache "github.com/Code-Hex/go-generics-cache"

	"github.com/platelk/woyaa/backend/domain"
)

type InMemoryCache struct {
	store  UserStorer
	client *cache.Cache[domain.UserID, *domain.User]
}

func NewInMemoryCache(store UserStorer) *InMemoryCache {
	return &InMemoryCache{
		store:  store,
		client: cache.New[domain.UserID, *domain.User](),
	}
}

func (r *InMemoryCache) WarmUp(c context.Context) error {
	users, err := r.store.GetAllUsers(c)
	if err != nil {
		return fmt.Errorf("can't warm up cache: %w", err)
	}
	for _, user := range users {
		_ = r.cacheUser(c, &user)
	}
	return nil
}

func (r *InMemoryCache) GetByID(c context.Context, id domain.UserID) (*domain.User, error) {
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

func (r *InMemoryCache) getFromCache(c context.Context, id domain.UserID) (*domain.User, error) {
	val, ok := r.client.Get(id)
	if !ok {
		return nil, fmt.Errorf("can't get from inMemory")
	}
	return val, nil
}

func (r *InMemoryCache) cacheUser(c context.Context, user *domain.User) error {
	r.client.Set(user.ID, user)
	return nil
}

func (r *InMemoryCache) GetAllUsers(c context.Context) (domain.Users, error) {
	var users domain.Users
	for _, id := range r.client.Keys() {
		user, _ := r.client.Get(id)
		users = append(users, *user)
	}
	return users, nil
}
