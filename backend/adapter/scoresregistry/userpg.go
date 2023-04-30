package scoresregistry

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

func (u *UserPG) RegisterScore(c context.Context, fromUserID domain.UserID, value int, reason string) error {
	err := u.db.Insert(c, userpg.ScoresTable, &userpg.Scores{
		UserID: int(fromUserID),
		Value:  value,
		Reason: reason,
	})
	if err != nil {
		return fmt.Errorf("can't insert score: %w", err)
	}
	return nil
}

func (u *UserPG) GetScoreOfUser(c context.Context, userID domain.UserID) (int, error) {
	var total struct {
		Count int `ksql:"count"`
		Total int `ksql:"total"`
	}
	err := u.db.QueryOne(c, &total, "SELECT COUNT(1) as count, COALESCE(SUM(score_value),0) as total FROM scores WHERE user_id = $1", userID)
	if err != nil {
		return 0, fmt.Errorf("can't retrieve scores: %w", err)
	}
	return total.Total, nil
}
