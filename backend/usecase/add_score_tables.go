package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type AddScoreTables func(ctx context.Context, req *AddScoreTablesReq) (*AddScoreTablesResp, error)

type AddScoreTablesReq struct {
	TableName string
	Score     int
	Reason    string
}
type AddScoreTablesResp struct {
}

func NewAddScoreTables(table TableRetriever, scorer Scorer) AddScoreTables {
	return func(ctx context.Context, req *AddScoreTablesReq) (*AddScoreTablesResp, error) {
		tables, err := table.GetTables(ctx)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve tables: %w", err)
		}
		for _, table := range tables {
			if table.Name == req.TableName {
				for _, userID := range table.UserIDs {
					err := scorer.RegisterScore(ctx, domain.UserID(userID), req.Score, req.Reason)
					if err != nil {
						return nil, fmt.Errorf("can't attribute score to table %s for user %d: %w", table.Name, userID, err)
					}
				}
				break
			}
		}
		return &AddScoreTablesResp{}, nil
	}
}
