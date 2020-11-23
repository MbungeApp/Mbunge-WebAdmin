/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package handler

import (
	"encoding/json"
	"fmt"
	"net/http"
	"reflect"

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
	g.GET("/edit/:id", participationHandler.editParticipation)
	g.PUT("/edit/:id", participationHandler.edit1Participation)
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
	var participationMap interface{}
	parti, err := p.participationService.GetParticipationById(id)
	if err != nil {
		return c.String(http.StatusBadRequest, "invalid participation id")
	}

	marshalParticipations, err := json.Marshal(parti)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err = json.Unmarshal(marshalParticipations, &participationMap)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	return c.Render(http.StatusOK, "participation_edit.html", participationMap)
}
func (p participationHandler) edit1Participation(c echo.Context) error {
	id := c.Param("id")
	participationReq := new(request.PartipationRequest)
	if err := c.Bind(participationReq); err != nil {
		return err
	}
	partiValue := reflect.ValueOf(participationReq)
	typeOfParti := partiValue.Type()
	for i := 0; i < typeOfParti.NumField(); i++ {
		fmt.Printf("Field: %s\tValue: %v\n", typeOfParti.Field(i).Name, partiValue.Field(i).Interface())
		err := p.participationService.EditParticipation(id, typeOfParti.Field(i).Name, partiValue.Field(i).Interface().(string))
		if err != nil {
			fmt.Println("Error updating: ", err.Error())
			return c.String(http.StatusInternalServerError, "error occurred")
		}
	}

	return c.Redirect(http.StatusOK, "/participation")
}
func (p participationHandler) deleteParticipation(c echo.Context) error {
	id := c.Param("id")

	err := p.participationService.DeleteParticipation(id)
	if err != nil {
		fmt.Println("Error deleting: ", err.Error())
		return c.String(http.StatusInternalServerError, "error occurred")
	}

	return c.Redirect(http.StatusOK, "/participation")
}
