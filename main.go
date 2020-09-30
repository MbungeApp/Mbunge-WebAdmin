/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package main

import (
	"errors"
	"fmt"
	"html/template"
	"io"
	"net/http"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"

	_dashboardHandler "mbunge-admin/v1/dashboard/handler"
	_homeHandler "mbunge-admin/v1/home/handler"
	_loginHandler "mbunge-admin/v1/login/handler"
)

type TemplateRegistry struct {
	templates map[string]*template.Template
}

// Implement e.Renderer interface
func (t *TemplateRegistry) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	tmpl, ok := t.templates[name]
	if !ok {
		err := errors.New("Template not found -> " + name)
		fmt.Println("##########################")
		return err
	}
	return tmpl.ExecuteTemplate(w, "base.html", data)
}

func main() {
	echo.NotFoundHandler = func(c echo.Context) error {
		// render your 404 page
		return c.Render(http.StatusOK, "404.html",nil )
	
	}
	// Echo instance
	e := echo.New()
	//session := config.ConnectDB()
	//renderer := &TemplateRenderer{
	//	templates: template.Must(template.ParseGlob("v1/templates/*.html")),
	//}
	//e.Renderer = renderer
	templates := make(map[string]*template.Template)
	templates["404.html"] = template.Must(template.ParseFiles("v1/templates/404.html", "v1/templates/base/base.html"))
	templates["dashboard.html"] = template.Must(template.ParseFiles("v1/templates/dashboard.html", "v1/templates/base/base.html"))
	templates["login.html"] = template.Must(template.ParseFiles("v1/templates/login.html", "v1/templates/base/base.html"))
	e.Renderer = &TemplateRegistry{
		templates: templates,
	}

	// middleware
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))

	_homeHandler.NewHomeHandler(e)
	_dashboardHandler.NewDashboardHandler(e)
	_loginHandler.NewLoginHandler(e)

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.Logger.Fatal(e.Start(":" + "1323"))
}
