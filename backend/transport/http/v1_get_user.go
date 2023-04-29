package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1userPath = "/api/v1/user"

func (b *Builder) V1User(getUser usecase.GetUserUseCase) *Builder {
	b.e.GET(v1userPath, v1UserHandler(getUser), b.authzMiddleware)

	return b
}

type userReq struct {
	ID int `json:"id"`
}

type userResp struct {
	User *domain.User `json:"user"`
}

func v1UserHandler(getUser usecase.GetUserUseCase) echo.HandlerFunc {
	return func(c echo.Context) error {
		var req userReq
		err := c.Bind(&req)
		if err != nil {
			return c.JSON(http.StatusBadRequest, nil)
		}
		id := req.ID
		if id == 0 {
			return c.NoContent(http.StatusBadRequest)
		}
		resp, err := getUser(c.Request().Context(), &usecase.GetUserReq{UserID: domain.UserID(id)})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, userResp{User: resp.User})
	}
}
