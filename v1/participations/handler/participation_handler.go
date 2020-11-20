/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package handler

import (
	"encoding/json"
	"net/http"

	//ms "github.com/mitchellh/mapstructure"
	"mbunge-admin/models/request"
	"mbunge-admin/v1/participations/service"

	"github.com/labstack/echo"
)

type participationHandler struct {
	participationService service.ParticipationService
}

// NewParticipationHandler ..
func NewParticipationHandler(e *echo.Echo, participationService service.ParticipationService) {
	participationHandler := &participationHandler{participationService: participationService}
	g := e.Group("/participation")
	g.GET("", participationHandler.getAllParticipations)
	g.POST("/add", participationHandler.addParticipation)
	g.GET("/view/:id", participationHandler.getOneParticipation)
	g.PUT("/edit/:id", participationHandler.editParticipation)
	g.DELETE("/delete/:id", participationHandler.deleteParticipation)
}

func (p participationHandler) getAllParticipations(c echo.Context) error {
	var participationMap []interface{}
	marshalParticipations, err := json.Marshal(p.participationService.GetAllParticipations())
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}

	err = json.Unmarshal(marshalParticipations, &participationMap)
	if err != nil {
		return c.String(http.StatusInternalServerError, err.Error())
	}
	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"data": participationMap,
	})
}
func (p participationHandler) addParticipation(c echo.Context) error {
	var participationMap []interface{}
	participationReq := new(request.PartipationRequest)
	if err := c.Bind(participationReq); err != nil {
		return err
	}
	err := p.participationService.AddParticipation(participationReq)

	marshalParticipations, error := json.Marshal(p.participationService.GetAllParticipations())
	if error != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	error = json.Unmarshal(marshalParticipations, &participationMap)
	if err != nil {
		return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
			"data":          participationMap,
			"notifications": "An error occurred",
		})
	} else {
		return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
			"data":          participationMap,
			"notifications": "Added Participation successfully",
		})
	}
}
func (p participationHandler) getOneParticipation(c echo.Context) error {
	id := c.Param("id")

	responses := p.participationService.GetAllResponses(id)
	return c.Render(http.StatusOK, "participation_detail.html", map[string]interface{}{
		"data": responses,
	})
}
func (p participationHandler) editParticipation(c echo.Context) error {
	id := c.Param("id")

	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"data":          p.participationService.GetAllParticipations(),
		"notifications": "Edited Participation successfully",
		"id":            id,
	})
}
func (p participationHandler) deleteParticipation(c echo.Context) error {
	id := c.Param("id")

	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"data":          p.participationService.GetAllParticipations(),
		"notifications": "Deleted Participation successfully",
		"id":            id,
	})
}
