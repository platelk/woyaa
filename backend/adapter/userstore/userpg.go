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
		ID:    domain.UserID(usr.ID),
		Email: domain.Email(usr.Email),
	}, nil
}
