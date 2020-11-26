package handler

import (
	"encoding/json"
	"fmt"
	"github.com/labstack/echo"
	"mbunge-admin/models/request"
	"mbunge-admin/v1/events/service"
	"net/http"
)

type eventHandler struct {
	eventService service.EventService
}

// NewEventHandler ..
func NewEventHandler(e *echo.Echo, event service.EventService) {
	eventHandler := &eventHandler{eventService: event}
	g := e.Group("/event")
	g.GET("", eventHandler.getAllEvents)
	g.POST("/add", eventHandler.addEvent)
	g.GET("/view/:id", eventHandler.getOneEvent)
	g.GET("/edit/:id", eventHandler.editEvent)
	g.POST("/edit/:id", eventHandler.edit1Event)
	g.GET("/delete/:id", eventHandler.deleteEvent)
}

func (e eventHandler) getAllEvents(c echo.Context) error {
	var eventMap []interface{}
	eventsDb, err := e.eventService.ViewAllEvents()
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	marshalEvents, err := json.Marshal(eventsDb)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err = json.Unmarshal(marshalEvents, &eventMap)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	return c.Render(http.StatusOK, "event.html", map[string]interface{}{
		"data": eventMap,
	})

}
func (e eventHandler) addEvent(c echo.Context) error {
	eventReq := new(request.EventRequest)
	if err := c.Bind(eventReq); err != nil {
		return err
	}
	err := e.eventService.AddEvent(eventReq)
	if err != nil {
		return err
	}
	return c.Redirect(http.StatusFound, "/event")
}
func (e eventHandler) getOneEvent(c echo.Context) error {
	return nil
}
func (e eventHandler) editEvent(c echo.Context) error {
	id := c.Param("id")
	var eventMap interface{}
	even := e.eventService.ViewEventById(id)

	marshalParticipations, err := json.Marshal(even)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err = json.Unmarshal(marshalParticipations, &eventMap)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}

	return c.Render(http.StatusOK, "event_edit.html", eventMap)
}
func (e eventHandler) edit1Event(c echo.Context) error {
	id := c.Param("id")
	eventReq := new(request.EventRequest)
	if err := c.Bind(eventReq); err != nil {
		return err
	}
	err := e.eventService.EditEvent(id, eventReq)
	if err != nil {
		return err
	}
	return c.Redirect(http.StatusFound, "/event")
}
func (e eventHandler) deleteEvent(c echo.Context) error {
	id := c.Param("id")

	err := e.eventService.DeleteEvent(id)
	if err != nil {
		fmt.Println("Error deleting: ", err.Error())
		return c.String(http.StatusInternalServerError, "error occurred")
	}

	return c.Redirect(http.StatusFound, "/event")
}
