package credstore

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

func (u *UserPG) ValidateEmail(c context.Context, credential domain.EmailCredential) (domain.UserID, error) {
	var usr userpg.User
	err := u.db.QueryOne(c, &usr, "FROM users WHERE email = $1", credential.Email)
	if err != nil {
		return 0, fmt.Errorf("can't retrieve user: %w", err)
	}
	return domain.UserID(usr.ID), nil
}
