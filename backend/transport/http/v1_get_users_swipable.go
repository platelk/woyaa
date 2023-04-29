package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1userSwipablePath = "/api/v1/user/swipable"

func (b *Builder) V1GetUserSwipable(getSwipableUser usecase.GetSwipableUser) *Builder {
	b.e.GET(v1userSwipablePath, v1UserSwipableHandler(getSwipableUser), b.authzMiddleware)

	return b
}

type userSwipableResp struct {
	Users []domain.UserID `json:"users"`
}

func v1UserSwipableHandler(getSwipableUser usecase.GetSwipableUser) echo.HandlerFunc {
	return func(c echo.Context) error {
		id := GetUserID(c)
		if id == 0 {
			return c.NoContent(http.StatusBadRequest)
		}
		resp, err := getSwipableUser(c.Request().Context(), &usecase.GetSwipableUserReq{UserID: domain.UserID(id)})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, userSwipableResp{Users: resp.Users})
	}
}
