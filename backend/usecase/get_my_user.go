package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type GetMyUserUseCase func(c context.Context, req *GetMyUserReq) (*GetMyUserResp, error)

type GetMyUserReq struct {
	UserID domain.UserID
}

type GetMyUserResp struct {
	Me *domain.User
}

func NewGetMyUserUseCase(userStore UserStoreByID) GetMyUserUseCase {
	return func(c context.Context, req *GetMyUserReq) (*GetMyUserResp, error) {
		currentUser, err := userStore.GetByID(c, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("can't get user with id %s associated to email %s: %w", req.UserID, err)
		}
		return &GetMyUserResp{Me: currentUser}, nil
	}
}
