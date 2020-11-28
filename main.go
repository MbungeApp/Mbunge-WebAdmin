/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package main

import (
	"errors"
	"html/template"
	"io"
	"net/http"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"

	"mbunge-admin/config"
	_dashboardHandler "mbunge-admin/v1/dashboard/handler"
	_dashboardService "mbunge-admin/v1/dashboard/service"
	_eventHandler "mbunge-admin/v1/events/handler"
	_eventService "mbunge-admin/v1/events/service"
	_homeHandler "mbunge-admin/v1/home/handler"
	_loginHandler "mbunge-admin/v1/login/handler"
	_mpHandler "mbunge-admin/v1/mp/handler"
	_mpService "mbunge-admin/v1/mp/service"
	_participationHandler "mbunge-admin/v1/participations/handler"
	_participationService "mbunge-admin/v1/participations/service"
)

// TemplateRegistry ..
type TemplateRegistry struct {
	templates map[string]*template.Template
}

// Render Implement e.Renderer interface
func (t *TemplateRegistry) Render(w io.Writer, name string, data interface{}, c echo.Context) error {
	tmpl, ok := t.templates[name]
	if !ok {
		err := errors.New("Template not found -> " + name)
		return err
	}
	return tmpl.ExecuteTemplate(w, "base.html", data)
}

func main() {
	echo.NotFoundHandler = func(c echo.Context) error {
		// render your 404 page
		return c.Render(http.StatusOK, "404.html", nil)

	}
	// Echo instance
	e := echo.New()
	session := config.ConnectDB()
	//renderer := &TemplateRenderer{
	//	templates: template.Must(template.ParseGlob("v1/templates/*.html")),
	//}
	//e.Renderer = renderer
	templates := make(map[string]*template.Template)
	templates["404.html"] = template.Must(template.ParseFiles("v1/templates/404.html", "v1/templates/base/base.html"))

	templates["login.html"] = template.Must(template.ParseFiles("v1/templates/login.html", "v1/templates/base/base.html"))
	templates["dashboard.html"] = template.Must(template.ParseFiles("v1/templates/dashboard.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["participation.html"] = template.Must(template.ParseFiles("v1/templates/participation/participation.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["participation_detail.html"] = template.Must(template.ParseFiles("v1/templates/participation/participation_detail.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["participation_edit.html"] = template.Must(template.ParseFiles("v1/templates/participation/participation_edit.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["event.html"] = template.Must(template.ParseFiles("v1/templates/event/event.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["event_detail.html"] = template.Must(template.ParseFiles("v1/templates/event/event_detail.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["event_edit.html"] = template.Must(template.ParseFiles("v1/templates/event/event_edit.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["mp.html"] = template.Must(template.ParseFiles("v1/templates/mp/mp.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["mp_detail.html"] = template.Must(template.ParseFiles("v1/templates/mp/mp_detail.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	templates["mp_edit.html"] = template.Must(template.ParseFiles("v1/templates/mp/mp_edit.html", "v1/templates/base/base.html", "v1/templates/base/sidebar.html"))
	e.Renderer = &TemplateRegistry{
		templates: templates,
	}

	// middleware
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))

	_homeHandler.NewHomeHandler(e)

	dashboardService := _dashboardService.NewDashboardServiceImpl(session)
	_dashboardHandler.NewDashboardHandler(e, dashboardService)

	participationService := _participationService.NewParticipationServiceImpl(session)
	_participationHandler.NewParticipationHandler(e, participationService)

	_loginHandler.NewLoginHandler(e)

	eventService := _eventService.NewEventServiceImpl(session)
	_eventHandler.NewEventHandler(e, eventService)

	mpService := _mpService.NewMpServiceImpl(session)
	_mpHandler.NewMpHandler(e, mpService)

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.Logger.Fatal(e.Start(":" + "8080"))
}
