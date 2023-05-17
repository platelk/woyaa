package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/usecase"
)

const v1AddScoreUser = "/api/v1/user/score"

func (b *Builder) V1PostAddScoreUser(user usecase.AddScoreUser) *Builder {
	b.e.POST(v1AddScoreUser, v1AddScoreUserHandler(user))

	return b
}

type addScoreUserReq struct {
	UserID int    `json:"user_id"`
	Score  int    `json:"score"`
	Reason string `json:"reason"`
}

func v1AddScoreUserHandler(user usecase.AddScoreUser) echo.HandlerFunc {
	return func(c echo.Context) error {
		req := &addScoreUserReq{}
		err := c.Bind(&req)
		if err != nil {
			return c.String(http.StatusBadRequest, err.Error())
		}
		_, err = user(c.Request().Context(), &usecase.AddScoreUserReq{
			UserID: req.UserID,
			Score:  req.Score,
			Reason: req.Reason,
		})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.NoContent(http.StatusOK)
	}
}
