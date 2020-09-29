/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package main

import (
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"net/http"

	_homeHandler "mbunge-admin/v1/home/handler"
)

func main() {
	// Echo instance
	e := echo.New()

	// middleware
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))

	_homeHandler.NewHomeHandler(e)

	//e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.Logger.Fatal(e.Start(":" + "1323"))
}
