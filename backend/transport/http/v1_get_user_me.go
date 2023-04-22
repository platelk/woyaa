package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1userMePath = "/api/v1/user/me"

func (b *Builder) V1UserMe(getMyUser usecase.GetMyUserUseCase) *Builder {
	b.e.GET(v1userMePath, v1UserMeHandler(getMyUser), b.authzMiddleware)

	return b
}

type userMeResp struct {
	Me *domain.User `json:"me"`
}

func v1UserMeHandler(getMyUser usecase.GetMyUserUseCase) echo.HandlerFunc {
	return func(c echo.Context) error {
		id := GetUserID(c)
		if id == 0 {
			return c.NoContent(http.StatusUnauthorized)
		}
		resp, err := getMyUser(c.Request().Context(), &usecase.GetMyUserReq{UserID: id})
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, userMeResp{Me: resp.Me})
	}
}
