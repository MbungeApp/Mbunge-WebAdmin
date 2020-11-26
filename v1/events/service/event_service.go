package service

import (
	"mbunge-admin/models/db"
	"mbunge-admin/models/request"
)

type EventService interface {
	ViewAllEvents() ([]db.EventNew, error)
	ViewEventById(id string) db.EventNew
	AddEvent(event *request.EventRequest) error
	EditEvent(id string, event *request.EventRequest) error
	DeleteEvent(id string) error
}
