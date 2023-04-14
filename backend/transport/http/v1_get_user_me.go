package http

import (
	"errors"
	"net/http"

	"github.com/golang-jwt/jwt/v5"
	"github.com/labstack/echo/v4"
	"github.com/rs/zerolog/log"
)

const v1userMePath = "/api/v1/user/me"

func (b *Builder) V1UserMe() *Builder {
	b.e.GET(v1userMePath, v1UserMeHandler(), b.authzMiddleware)

	return b
}

type userMeReq struct {
}

type userMeResp struct {
}

func v1UserMeHandler() echo.HandlerFunc {
	return func(c echo.Context) error {
		log.Debug().Msg(c.Request().Header.Get("Authorization"))
		token, ok := c.Get("user").(*jwt.Token) // by default token is stored under `user` key
		if !ok {
			return c.String(http.StatusInternalServerError, errors.New("JWT token missing or invalid").Error())
		}
		claims, ok := token.Claims.(jwt.MapClaims) // by default claims is of type `jwt.MapClaims`
		if !ok {
			return c.String(http.StatusInternalServerError, errors.New("failed to cast claims as jwt.MapClaims").Error())
		}
		return c.JSON(http.StatusOK, claims)
	}
}
