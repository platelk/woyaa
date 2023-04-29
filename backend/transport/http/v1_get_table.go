package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1TablePath = "/api/v1/table"

type getTablesResp struct {
	Tables []domain.Table `json:"tables"`
}

func (b *Builder) V1GetTables(tables usecase.GetTables) *Builder {
	b.e.GET(v1TablePath, v1GetTablesHandler(tables), b.authzMiddleware)

	return b
}

func v1GetTablesHandler(tables usecase.GetTables) echo.HandlerFunc {
	return func(c echo.Context) error {
		resp, err := tables(c.Request().Context(), &usecase.GetTablesReq{})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, getTablesResp{
			Tables: resp.Tables,
		})
	}
}
