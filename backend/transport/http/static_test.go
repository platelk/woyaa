package http

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/require"
)

func TestBuilder_WebSite(t *testing.T) {
	s := NewBuilder().WebSite("../../../build/web").Build()

	req := httptest.NewRequest(http.MethodGet, "/index.html", nil)
	req.Header.Set(echo.HeaderContentType, echo.MIMETextHTML)
	rec := httptest.NewRecorder()
	s.e.ServeHTTP(rec, req)

	require.Equal(t, rec.Code, http.StatusOK)
}
