package http

import (
	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
)

func GetUserID(c echo.Context) domain.UserID {
	return domain.UserID(c.Get("user_id").(domain.UserID))
}

func SetUserID(c echo.Context, userID domain.UserID) {
	c.Set("user_id", userID)
}

func GetUserEmail(c echo.Context) domain.Email {
	return domain.Email(c.Get("user_email").(domain.Email))
}

func SetUserEmail(c echo.Context, userEmail domain.Email) {
	c.Set("user_email", userEmail)
}
