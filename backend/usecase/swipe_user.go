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
	FoundMyTable       bool
	NotFoundMyTable    bool
	FoundNotMyTable    bool
	NotFoundNotMyTable bool
}

type SwipeUserUseCase func(ctx context.Context, req *SwipeUserReq) (*SwipeUserResp, error)

type Swiper interface {
	InsertSwipe(c context.Context, fromUserID, swipedUserID domain.UserID, right bool) error
}

type Scorer interface {
	RegisterScore(c context.Context, fromUserID domain.UserID, value int, reason string) error
}

func NewSwipeUserUseCase(swiper Swiper, userStore UserStoreByID, scorer Scorer) SwipeUserUseCase {
	return func(ctx context.Context, req *SwipeUserReq) (*SwipeUserResp, error) {
		currentUser, err := userStore.GetByID(ctx, req.FromUser)
		if err != nil {
			return nil, fmt.Errorf("can't get user with id %s associated to email %s: %w", req.FromUser, err)
		}
		swipedUser, err := userStore.GetByID(ctx, req.SwipedUser)
		if err != nil {
			return nil, fmt.Errorf("can't get user with id %s associated to email %s: %w", req.SwipedUser, err)
		}
		err = swiper.InsertSwipe(ctx, req.FromUser, req.SwipedUser, req.SwipedRight)
		if err != nil {
			return nil, fmt.Errorf("can't insert swipe from user %v of user %v: %w", req.FromUser, req.SwipedUser, err)
		}
		points := 0
		reason := "none"
		var resp SwipeUserResp
		switch {
		case currentUser.Table == swipedUser.Table && req.SwipedRight:
			points = 5
			reason = fmt.Sprintf("correct swipe of %d at table", swipedUser.ID)
			resp.FoundMyTable = true
		case currentUser.Table != swipedUser.Table && !req.SwipedRight:
			points = 2
			reason = fmt.Sprintf("correct swipe of %d not at table", swipedUser.ID)
			resp.FoundNotMyTable = true
		case currentUser.Table != swipedUser.Table && req.SwipedRight:
			points = -1
			reason = fmt.Sprintf("correct swipe of %d not at table", swipedUser.ID)
			resp.NotFoundNotMyTable = true
		case currentUser.Table == swipedUser.Table && !req.SwipedRight:
			points = -2
			reason = fmt.Sprintf("correct swipe of %d not at table", swipedUser.ID)
			resp.NotFoundMyTable = true
		}
		err = scorer.RegisterScore(ctx, req.FromUser, points, reason)
		if err != nil {
			return nil, fmt.Errorf("can't insert score from user %v of user %v: %w", req.FromUser, req.SwipedUser, err)
		}
		return &resp, nil
	}
}
