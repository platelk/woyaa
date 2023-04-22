package userstore

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/infra/userpg"
)

type UserPG struct {
	db *userpg.DB
}

func NewUserPG(db *userpg.DB) *UserPG {
	return &UserPG{
		db: db,
	}
}

func (u *UserPG) GetByID(c context.Context, id domain.UserID) (*domain.User, error) {
	var usr userpg.User
	err := u.db.QueryOne(c, &usr, "FROM users WHERE id = $1", id)
	if err != nil {
		return nil, fmt.Errorf("can't retrieve user: %w", err)
	}
	return &domain.User{
		ID:               domain.UserID(usr.ID),
		FirstName:        usr.FirstName,
		LastName:         usr.LastName,
		Email:            domain.Email(usr.Email),
		Room:             domain.RoomNumber(usr.Room),
		Table:            domain.TableName(usr.Table),
		FullPicturePath:  usr.FullPicturePath,
		RoundPicturePath: usr.RoundPicturePath,
	}, nil
}

func (u *UserPG) GetAllUsers(c context.Context) (domain.Users, error) {
	var usr []userpg.User
	err := u.db.Query(c, &usr, "SELECT * FROM users")
	if err != nil {
		return nil, fmt.Errorf("can't retrieve user: %w", err)
	}
	var users []domain.User
	for _, u := range usr {
		users = append(users, domain.User{
			ID:               domain.UserID(u.ID),
			FirstName:        u.FirstName,
			LastName:         u.LastName,
			Email:            domain.Email(u.Email),
			Room:             domain.RoomNumber(u.Room),
			Table:            domain.TableName(u.Table),
			FullPicturePath:  u.FullPicturePath,
			RoundPicturePath: u.RoundPicturePath,
		})
	}
	return users, nil
}
