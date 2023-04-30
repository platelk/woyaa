package tablestore

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

type Table struct {
	Name  string `ksql:"name"`
	Total int    `ksql:"total"`
}

func (u *UserPG) GetTables(c context.Context) ([]domain.Table, error) {
	var rawTables []Table
	err := u.db.Query(c, &rawTables, "SELECT wedding_table as name, COUNT(1) as total FROM users GROUP BY wedding_table")
	if err != nil {
		return nil, fmt.Errorf("can't retrieve scores: %w", err)
	}
	var tables []domain.Table
	for _, t := range rawTables {
		tables = append(tables, domain.Table{
			Name:  t.Name,
			Total: t.Total,
		})
	}
	return tables, nil
}
