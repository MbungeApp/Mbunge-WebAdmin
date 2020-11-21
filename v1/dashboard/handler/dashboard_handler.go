/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package handler

import (
	"encoding/json"
	"github.com/labstack/echo"
	"mbunge-admin/v1/dashboard/service"
	"net/http"
)

type dashboardHandler struct {
	dashboardService service.DashboardServices
}

func NewDashboardHandler(e *echo.Echo, dashService service.DashboardServices) {
	dashboardHandler := &dashboardHandler{
		dashboardService: dashService,
	}
	g := e.Group("/dashboard")
	g.GET("", dashboardHandler.home)
}

func (d dashboardHandler) home(c echo.Context) error {
	var metrics interface{}
	marshalMetrics, err := json.Marshal(d.dashboardService.GetMetrics())
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}

	err = json.Unmarshal(marshalMetrics, metrics)
	return c.Render(http.StatusOK, "dashboard.html", map[string]interface{}{
		"data": metrics,
	})
}
