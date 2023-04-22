package custommiddleware

import (
	"context"
	"errors"
	"net/http"
	"strconv"
	"strings"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/adapter/accesstokens"
	"github.com/platelk/woyaa/backend/domain"
)

type TokenValidator interface {
	ValidateAccessToken(c context.Context, token string) (*accesstokens.Claims, error)
}

func JWT(validator TokenValidator) func(next echo.HandlerFunc) echo.HandlerFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			authzHeader := c.Request().Header.Get("Authorization")
			if authzHeader == "" {
				return c.NoContent(http.StatusUnauthorized)
			}
			token := strings.Split(authzHeader, " ")
			if len(token) == 0 {
				return c.NoContent(http.StatusUnauthorized)
			}
			claims, err := validator.ValidateAccessToken(c.Request().Context(), token[len(token)-1])
			switch {
			case errors.Is(err, accesstokens.ErrSignatureInvalid) || errors.Is(err, accesstokens.ErrTokenInvalid):
				return c.String(http.StatusUnauthorized, err.Error())
			case err != nil:
				return c.String(http.StatusInternalServerError, err.Error())
			}
			usr := strings.Split(claims.Subject, ":")
			id, _ := strconv.Atoi(usr[0])
			c.Set("user_id", domain.UserID(id))
			c.Set("user_email", domain.Email(usr[1]))
			return next(c)
		}
	}
}
