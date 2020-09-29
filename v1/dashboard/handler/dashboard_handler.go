/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package handler

import (
	"github.com/labstack/echo"
	"net/http"
)

func NewDashboardHandler(e *echo.Echo) {
	g := e.Group("/dashboard")
	g.GET("", home)
}

func home(c echo.Context) error {
	return c.Render(http.StatusOK, "dashboard.html", map[string]interface{}{
		"name": "Dolly!",
	})
}
