package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type GetUserUseCase func(c context.Context, req *GetUserReq) (*GetUserResp, error)

type GetUserReq struct {
	UserID domain.UserID
}

type GetUserResp struct {
	User *domain.User
}

func NewGetUserUseCase(userStore UserStoreByID) GetUserUseCase {
	return func(c context.Context, req *GetUserReq) (*GetUserResp, error) {
		currentUser, err := userStore.GetByID(c, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("can't get user with id %s associated to email %s: %w", req.UserID, err)
		}
		return &GetUserResp{User: currentUser}, nil
	}
}
