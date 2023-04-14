package http

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/require"
)

func TestBuilder_V1EmailLogin_bad_format(t *testing.T) {
	s := NewBuilder().V1EmailLogin(nil).Build()

	req := httptest.NewRequest(http.MethodPost, "/api/v1/login/email", strings.NewReader(`plop"`))
	req.Header.Set(echo.HeaderContentType, echo.MIMETextHTML)
	rec := httptest.NewRecorder()
	s.e.ServeHTTP(rec, req)

	require.Equal(t, rec.Code, http.StatusBadRequest)
}

func TestBuilder_V1EmailLogin_empty_email(t *testing.T) {
	s := NewBuilder().V1EmailLogin(nil).Build()

	req := httptest.NewRequest(http.MethodPost, "/api/v1/login/email", strings.NewReader(`{"email": ""}"`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	s.e.ServeHTTP(rec, req)

	require.Equal(t, rec.Code, http.StatusBadRequest)
}

func TestBuilder_V1EmailLogin(t *testing.T) {
	s := NewBuilder().V1EmailLogin(nil).Build()

	req := httptest.NewRequest(http.MethodPost, "/api/v1/login/email", strings.NewReader(`{"email": "test@test.com"}"`))
	req.Header.Set(echo.HeaderContentType, echo.MIMEApplicationJSON)
	rec := httptest.NewRecorder()
	s.e.ServeHTTP(rec, req)

	require.Equal(t, rec.Code, http.StatusOK)
}
