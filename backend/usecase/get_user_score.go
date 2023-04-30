package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type GetUserScore func(ctx context.Context, req *GetUserScoreReq) (*GetUserScoreResp, error)

type GetUserScoreReq struct {
	UserID domain.UserID
}

type GetUserScoreResp struct {
	Total int
}

type ScoreRetriever interface {
	GetScoreOfUser(ctx context.Context, id domain.UserID) (int, error)
}

func NewGetUserScoreUseCase(scoreRetriever ScoreRetriever) GetUserScore {
	return func(ctx context.Context, req *GetUserScoreReq) (*GetUserScoreResp, error) {
		total, err := scoreRetriever.GetScoreOfUser(ctx, req.UserID)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve user score: %w", err)
		}
		return &GetUserScoreResp{Total: total}, nil
	}
}
