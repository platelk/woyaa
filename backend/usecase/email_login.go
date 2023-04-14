package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type EmailLoginReq struct {
	EmailCred domain.EmailCredential
}

type EmailLoginResponse struct {
	AccessToken domain.AccessToken
}

type EmailLoginUseCase func(c context.Context, req *EmailLoginReq) (*EmailLoginResponse, error)

type CredentialStore interface {
	ValidateEmail(c context.Context, credential domain.EmailCredential) (domain.UserID, error)
}

type UserStore interface {
	GetByID(c context.Context, id domain.UserID) (*domain.User, error)
}

type TokenGenerator interface {
	GenerateAccessToken(c context.Context, user *domain.User) (domain.AccessToken, error)
}

func NewEmailLogin(credStore CredentialStore, userStore UserStore, tokenGenerator TokenGenerator) EmailLoginUseCase {
	return func(c context.Context, req *EmailLoginReq) (*EmailLoginResponse, error) {
		userID, err := credStore.ValidateEmail(c, req.EmailCred)
		if err != nil {
			return nil, fmt.Errorf("can't validate email %s: %w", req.EmailCred.Email, err)
		}
		currentUser, err := userStore.GetByID(c, userID)
		if err != nil {
			return nil, fmt.Errorf("can't get user with id %s associated to email %s: %w", userID, req.EmailCred, err)
		}
		token, err := tokenGenerator.GenerateAccessToken(c, currentUser)
		if err != nil {
			return nil, fmt.Errorf("can't generate tokens for user with id %s associated to email %s: %w", userID, req.EmailCred, err)
		}
		return &EmailLoginResponse{
			AccessToken: token,
		}, nil
	}
}
