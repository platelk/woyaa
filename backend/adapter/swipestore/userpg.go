package swipestore

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

func (u *UserPG) InsertSwipe(c context.Context, fromUserID, swipedUserID domain.UserID, right bool) error {
	err := u.db.Insert(c, userpg.SwipesTable, &userpg.Swipes{
		UserID:       int(fromUserID),
		SwipedUserID: int(swipedUserID),
		SwipedRight:  right,
	})
	if err != nil {
		return fmt.Errorf("can't insert swipe: %w", err)
	}
	return nil
}

func (u *UserPG) GetAllSwipesOfUserID(c context.Context, userID domain.UserID) (domain.Swipes, error) {
	var swp []userpg.Swipes
	err := u.db.Query(c, &swp, "SELECT * FROM swipes WHERE user_id = $1", userID)
	if err != nil {
		return nil, fmt.Errorf("can't retrieve swipes: %w", err)
	}
	var swipes []domain.Swipe
	for _, s := range swp {
		swipes = append(swipes, domain.Swipe{
			FromUserID:   domain.UserID(s.UserID),
			SwipedUserID: domain.UserID(s.SwipedUserID),
			SwipedRight:  s.SwipedRight,
			At:           s.SwipedAt,
		})
	}
	return swipes, nil
}
