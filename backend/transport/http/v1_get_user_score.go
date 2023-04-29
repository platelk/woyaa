package http

import (
	"net/http"
	"strconv"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1UserScorePath = "/api/v1/user/score"

func (b *Builder) V1GetUserScore(getUserScore usecase.GetUserScore) *Builder {
	b.e.GET(v1UserScorePath, v1UserScoreHandler(getUserScore), b.authzMiddleware)

	return b
}

type userScoreResp struct {
	Total int `json:"total"`
}

func v1UserScoreHandler(getUserScore usecase.GetUserScore) echo.HandlerFunc {
	return func(c echo.Context) error {
		userID, err := strconv.Atoi(c.QueryParam("id"))
		if err != nil {
			return c.String(http.StatusBadRequest, "can't parse provided id")
		}
		id := userID
		if id == 0 {
			return c.NoContent(http.StatusBadRequest)
		}
		resp, err := getUserScore(c.Request().Context(), &usecase.GetUserScoreReq{UserID: domain.UserID(id)})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, userScoreResp{Total: resp.Total})
	}
}
