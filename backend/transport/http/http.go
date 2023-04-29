package http

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"

	"github.com/platelk/woyaa/backend/adapter/accesstokens"
	"github.com/platelk/woyaa/backend/transport/http/custommiddleware"
)

type Builder struct {
	addr            string
	e               *echo.Echo
	authzMiddleware echo.MiddlewareFunc
}

func NewBuilder() *Builder {
	return &Builder{
		e:    echo.New(),
		addr: ":8080",
	}
}

func (b *Builder) WithJWT(jwt *accesstokens.JWTAccessToken) *Builder {
	b.authzMiddleware = custommiddleware.JWT(jwt)
	return b
}

func (b *Builder) Addr(addr string) *Builder {
	b.addr = addr
	return b
}

func (b *Builder) Build() *server {
	return &server{
		e:    b.e,
		addr: b.addr,
	}
}

type server struct {
	e    *echo.Echo
	addr string
}

func (s *server) Start() error {
	s.e.Use(middleware.Logger())
	s.e.Use(middleware.Recover())
	s.e.Use(middleware.RequestID())
	return s.e.Start(s.addr)
}
