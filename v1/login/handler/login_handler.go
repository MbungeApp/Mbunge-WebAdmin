/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package handler

import (
	"github.com/labstack/echo"
	"net/http"
)

func NewLoginHandler(e *echo.Echo) {
	g := e.Group("/login")
	g.GET("", login)
}

func login(c echo.Context) error {
	return c.Render(http.StatusOK, "login.html", map[string]interface{}{
		"name": "Dolly!",
	})
}