package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type AddScoreUser func(ctx context.Context, req *AddScoreUserReq) (*AddScoreUserResp, error)

type AddScoreUserReq struct {
	UserID int
	Score  int
	Reason string
}
type AddScoreUserResp struct {
}

func NewAddScoreUser(scorer Scorer) AddScoreUser {
	return func(ctx context.Context, req *AddScoreUserReq) (*AddScoreUserResp, error) {
		err := scorer.RegisterScore(ctx, domain.UserID(req.UserID), req.Score, req.Reason)
		if err != nil {
			return nil, fmt.Errorf("can't attribute score for user %d: %w", req.UserID, err)
		}
		return &AddScoreUserResp{}, nil
	}
}
