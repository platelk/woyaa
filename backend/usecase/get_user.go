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

func NewGetUserUseCase(userStore UserStoreByID, scoreRetriever ScoreRetriever) GetUserUseCase {
	return func(c context.Context, req *GetUserReq) (*GetUserResp, error) {
		currentUser, err := userStore.GetByID(c, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("can't get user with id %s associated to email %s: %w", req.UserID, err)
		}
		total, err := scoreRetriever.GetScoreOfUser(c, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve score of user %d: %w", req.UserID, err)
		}
		currentUser.Score = total
		return &GetUserResp{User: currentUser}, nil
	}
}
