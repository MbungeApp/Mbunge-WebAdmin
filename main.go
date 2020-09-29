/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package main

import (
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
	"html/template"
	"io"
	"net/http"

	_dashboardHandler "mbunge-admin/v1/dashboard/handler"
	_homeHandler "mbunge-admin/v1/home/handler"
)

type TemplateRenderer struct {
	templates *template.Template
}

// Render renders a template document
func (t *TemplateRenderer) Render(w io.Writer, name string, data interface{}, c echo.Context) error {

	// Add global methods if data is a map
	if viewContext, isMap := data.(map[string]interface{}); isMap {
		viewContext["reverse"] = c.Echo().Reverse
	}

	return t.templates.ExecuteTemplate(w, name, data)
}

func main() {
	// Echo instance
	e := echo.New()
	//session := config.ConnectDB()
	renderer := &TemplateRenderer{
		templates: template.Must(template.ParseGlob("v1/templates/*.html")),
	}
	e.Renderer = renderer

	// middleware
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))

	_homeHandler.NewHomeHandler(e)
	_dashboardHandler.NewDashboardHandler(e)

	//e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.Logger.Fatal(e.Start(":" + "1323"))
}
