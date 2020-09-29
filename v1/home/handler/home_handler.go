package handler

import (
	"github.com/labstack/echo"
)

func NewHomeHandler(e *echo.Echo) {
	e.Static("/static", "v1/static")
	e.File("/", "v1/home/index.html")
}
