package http

import (
	"net/http"

	"github.com/labstack/echo/v4"

	"github.com/platelk/woyaa/backend/domain"
	"github.com/platelk/woyaa/backend/usecase"
)

const v1LoginEmailPath = "/api/v1/login/email"

func (b *Builder) V1PostEmailLogin(emailLogin usecase.EmailLoginUseCase) *Builder {
	b.e.POST(v1LoginEmailPath, v1EmailLoginHandler(emailLogin))

	return b
}

type loginEmailReq struct {
	Email string `json:"email"`
}

type loginEmailResp struct {
	AccessToken string `json:"access_token"`
}

func v1EmailLoginHandler(emailLogin usecase.EmailLoginUseCase) echo.HandlerFunc {
	return func(c echo.Context) error {
		// Parse incoming request
		emailLoginReq := &loginEmailReq{}
		err := c.Bind(&emailLoginReq)
		if err != nil {
			return c.JSON(http.StatusBadRequest, nil)
		}
		if emailLoginReq.Email == "" {
			return c.JSON(http.StatusBadRequest, nil)
		}
		// Execute request
		req, err := emailLogin(c.Request().Context(), &usecase.EmailLoginReq{EmailCred: domain.EmailCredential{Email: domain.Email(emailLoginReq.Email)}})
		// return
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		return c.JSON(http.StatusOK, loginEmailResp{AccessToken: string(req.AccessToken)})
	}
}
