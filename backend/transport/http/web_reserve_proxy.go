package http

import (
	"net/url"

	"github.com/labstack/echo/v4/middleware"
)

// ReverseProxy to a development website
func (b *Builder) ReverseProxy(path string) *Builder {
	u, _ := url.Parse(path)
	b.e.Group("/proxy").Use(middleware.Proxy(middleware.NewRandomBalancer([]*middleware.ProxyTarget{{URL: u}})))
	return b
}
