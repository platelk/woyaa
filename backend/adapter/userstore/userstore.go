package userstore

import (
	"context"

	"github.com/platelk/woyaa/backend/domain"
)

type UserStorer interface {
	GetByID(c context.Context, id domain.UserID) (*domain.User, error)
	GetAllUsers(c context.Context) (domain.Users, error)
}
