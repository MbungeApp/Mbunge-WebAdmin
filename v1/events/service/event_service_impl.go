package service

import (
	"fmt"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/dao"
	"mbunge-admin/models/db"
	"mbunge-admin/models/request"
)

type eventServiceImpl struct {
	eventAndNewsDao dao.NewsDaoInterface
}

func NewEventServiceImpl(client *mongo.Client) EventService {
	return &eventServiceImpl{
		eventAndNewsDao: dao.NewNewsDaoInterface{
			Client: client,
		},
	}
}

func (e eventServiceImpl) ViewAllEvents() ([]db.EventNew, error) {
	events, err := e.eventAndNewsDao.ReadAllNews()
	if err != nil {
		return nil, err
	}
	return events, nil
}
func (e eventServiceImpl) ViewEventById(id string) db.EventNew {
	events := e.eventAndNewsDao.ReadOneNews(id)
	return events
}

func (e eventServiceImpl) AddEvent(event *request.EventRequest) error {
	eventDb := db.EventNew{
		Name:    event.Name,
		Body:    event.Body,
		Picture: event.Picture,
	}
	err := e.eventAndNewsDao.CreateNews(eventDb)
	if err != nil {
		return err
	}
	return nil
}

func (e eventServiceImpl) EditEvent(id string, event *request.EventRequest) error {
	originalEvent := e.eventAndNewsDao.ReadOneNews(id)

	if event.Name != originalEvent.Name {
		err := e.eventAndNewsDao.UpdateNews(id, "name", event.Name)
		if err != nil {
			return err
		}
	} else if event.Picture != originalEvent.Picture {
		err := e.eventAndNewsDao.UpdateNews(id, "picture", event.Picture)
		if err != nil {
			return err
		}
	} else if event.Body != originalEvent.Body {
		err := e.eventAndNewsDao.UpdateNews(id, "body", event.Body)
		if err != nil {
			return err
		}
	} else {
		fmt.Println("******************** nothing *******************")
	}

	return nil
}

func (e eventServiceImpl) DeleteEvent(id string) error {
	err := e.eventAndNewsDao.DeleteNews(id)
	if err != nil {
		return err
	}
	return nil
}
