package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type GetSwipableUser func(c context.Context, req *GetSwipableUserReq) (*GetSwipableUserResp, error)

type GetSwipableUserReq struct {
	UserID domain.UserID
}

type GetSwipableUserResp struct {
	Users []domain.UserID
}

type UserStoreAll interface {
	GetAllUsers(c context.Context) (domain.Users, error)
}

type SwipeStoreByUser interface {
	GetAllSwipesOfUserID(c context.Context, userID domain.UserID) (domain.Swipes, error)
}

func NewGetSwipableUserUseCase(userStore UserStoreAll, swipeStore SwipeStoreByUser, retriever ScoreRetriever) GetSwipableUser {
	return func(c context.Context, req *GetSwipableUserReq) (*GetSwipableUserResp, error) {
		users, err := userStore.GetAllUsers(c)
		if err != nil {
			return nil, fmt.Errorf("can't get all users: %w", err)
		}
		currentUserSwipe, err := swipeStore.GetAllSwipesOfUserID(c, req.UserID)
		result := users.IDs().Difference(currentUserSwipe.IDs())

		return &GetSwipableUserResp{Users: result.Keys()}, nil
	}
}
