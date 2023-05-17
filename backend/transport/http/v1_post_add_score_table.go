package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/usecase"
)

const v1AddScoreTable = "/api/v1/table/score"

func (b *Builder) V1PostAddScoreTable(table usecase.AddScoreTables) *Builder {
	b.e.POST(v1AddScoreTable, v1AddScoreTableHandler(table))

	return b
}

type addScoreTableReq struct {
	TableName string `json:"table_name"`
	Score     int    `json:"score"`
	Reason    string `json:"reason"`
}

func v1AddScoreTableHandler(table usecase.AddScoreTables) echo.HandlerFunc {
	return func(c echo.Context) error {
		req := &addScoreTableReq{}
		err := c.Bind(&req)
		if err != nil {
			return c.String(http.StatusBadRequest, err.Error())
		}
		_, err = table(c.Request().Context(), &usecase.AddScoreTablesReq{
			TableName: req.TableName,
			Score:     req.Score,
			Reason:    req.Reason,
		})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	}
}
