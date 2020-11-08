/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package handler

import (
	"net/http"

	"mbunge-admin/models/request"

	"github.com/labstack/echo"
)

// NewParticipationHandler ..
func NewParticipationHandler(e *echo.Echo) {
	g := e.Group("/participation")
	g.GET("", getAllParticipations)
	g.POST("/add", addParticipation)
	g.GET("/view/:id", getOneParticipation)
	g.PUT("/edit/:id", editParticipation)
	g.DELETE("/delete/:id", deleteParticipation)
}

func getAllParticipations(c echo.Context) error {
	// TODO
	// Fetch all participations
	// marshall them to json
	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"name":          "Dolly!",
		"notifications": "View Participation successfully",
	})
}
func addParticipation(c echo.Context) error {
	participationReq := new(request.PartipationRequest)
	if err := c.Bind(participationReq); err != nil {
		return err
	}
	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"data":          "1234",
		"notifications": "Added Participation successfully",
	})
}
func getOneParticipation(c echo.Context) error {
	id := c.Param("id")

	// TODO
	// add fetch participation responses
	return c.String(http.StatusOK, id)
}
func editParticipation(c echo.Context) error {
	id := c.Param("id")

	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"name":          "Dolly!",
		"notifications": "Edited Participation successfully",
		"id":            id,
	})
}
func deleteParticipation(c echo.Context) error {
	id := c.Param("id")

	return c.Render(http.StatusOK, "participation.html", map[string]interface{}{
		"name":          "Dolly!",
		"notifications": "Deleted Participation successfully",
		"id":            id,
	})
}
