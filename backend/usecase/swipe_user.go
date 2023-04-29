package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type SwipeUserReq struct {
	FromUser    domain.UserID
	SwipedUser  domain.UserID
	SwipedRight bool
}

type SwipeUserResp struct {
}

type SwipeUserUseCase func(ctx context.Context, req *SwipeUserReq) (*SwipeUserResp, error)

type Swiper interface {
	InsertSwipe(c context.Context, fromUserID, swipedUserID domain.UserID, right bool) error
}

func NewSwipeUserUseCase(swiper Swiper) SwipeUserUseCase {
	return func(ctx context.Context, req *SwipeUserReq) (*SwipeUserResp, error) {
		err := swiper.InsertSwipe(ctx, req.FromUser, req.SwipedUser, req.SwipedRight)
		if err != nil {
			return nil, fmt.Errorf("can't insert swipe from user %v of user %v: %w", req.FromUser, req.SwipedUser, err)
		}
		return &SwipeUserResp{}, nil
	}
}
