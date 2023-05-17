package http

import (
	"context"
	"encoding/csv"
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/infra/userpg"
)

func (b *Builder) DevUserPGAll(pg *userpg.DB) *Builder {
	return b.DevUserPGImport(pg).DevUserPGDrop(pg).DevUserPGSetup(pg).DevUserPGImportSurvey(pg).DevUserPGUserSetup(pg).DevUserPGUserDrop(pg).DevUserPGSurveySetup(pg).DevUserPGSurveyDrop(pg)
}

func (b *Builder) DevUserPGSetup(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/setup", func(c echo.Context) error {
		err := pg.CreateTables(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGUserSetup(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/users/setup", func(c echo.Context) error {
		err := pg.CreateUsersTable(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGUserDrop(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/user/drop", func(c echo.Context) error {
		err := pg.DropUserTable(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	b.e.DELETE("/dev/userpg/user", func(c echo.Context) error {
		err := pg.DropUserTable(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGSurveySetup(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/survey/setup", func(c echo.Context) error {
		err := pg.CreateSurveyTable(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGSurveyDrop(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/survey/drop", func(c echo.Context) error {
		err := pg.DropSurveyTable(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	b.e.DELETE("/dev/userpg/survey", func(c echo.Context) error {
		err := pg.DropSurveyTable(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGDrop(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/drop", func(c echo.Context) error {
		err := pg.DropTables(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	b.e.DELETE("/dev/userpg", func(c echo.Context) error {
		err := pg.DropTables(context.Background())
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGImport(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/import", func(c echo.Context) error {
		r := csv.NewReader(c.Request().Body)
		err := pg.ImportCSV(context.Background(), r)
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}

func (b *Builder) DevUserPGImportSurvey(pg *userpg.DB) *Builder {
	b.e.POST("/dev/userpg/import/survey", func(c echo.Context) error {
		r := csv.NewReader(c.Request().Body)
		err := pg.ImportSurveyCSV(context.Background(), r)
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	})
	return b
}
