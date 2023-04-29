package usecase

import (
	"context"
	"fmt"

	"github.com/platelk/woyaa/backend/domain"
)

type GetTables func(ctx context.Context, req *GetTablesReq) (*GetTablesResp, error)

type GetTablesReq struct{}
type GetTablesResp struct {
	Tables []domain.Table
}

type TableRetriever interface {
	GetTables(c context.Context) ([]domain.Table, error)
}

func NewGetTables(table TableRetriever) GetTables {
	return func(ctx context.Context, req *GetTablesReq) (*GetTablesResp, error) {
		tables, err := table.GetTables(ctx)
		if err != nil {
			return nil, fmt.Errorf("can't retrieve tables: %w", tables)
		}
		return &GetTablesResp{Tables: tables}, nil
	}
}
