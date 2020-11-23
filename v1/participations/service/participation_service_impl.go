package service

import (
	"mbunge-admin/dao"
	"mbunge-admin/models/db"
	"mbunge-admin/models/request"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
)

type participationServiceImpl struct {
	participationDao dao.ParticipationDaoInterface
	responseDao      dao.ResponseDaoInterface
}

// NewparticipationServiceImpl ..
func NewparticipationServiceImpl(client *mongo.Client) ParticipationService {
	partiDao := dao.NewParticipationDaoInterface{
		Client: client,
	}
	resDao := dao.NewResponseDaoInterface{
		Client: client,
	}
	return &participationServiceImpl{
		participationDao: partiDao,
		responseDao:      resDao,
	}
}

// Device implementations
func (p participationServiceImpl) GetAllParticipations() []db.Participation {
	participations := p.participationDao.ReadAllParticipation()
	return participations
}
func (p participationServiceImpl) AddParticipation(addParticipation *request.PartipationRequest) error {
	layout := "2006-01-02"
	t, err := time.Parse(layout, addParticipation.ExpireAt)

	if err != nil {
		return err
	}
	participation := db.Participation{
		Name:     addParticipation.Name,
		Sector:   addParticipation.Sector,
		Body:     addParticipation.Body,
		PostedBy: addParticipation.PostedBy,
		ExpireAt: t,
	}
	err = p.participationDao.CreateParticipation(participation)
	if err != nil {
		return err
	}
	return nil
}
func (p participationServiceImpl) GetParticipationById(id string) (db.Participation, error) {

	participation, err := p.participationDao.ReadOneParticipation(id)
	if err != nil {
		return db.Participation{}, err
	}
	return participation, nil
}
func (p participationServiceImpl) EditParticipation(id string, key string, value string) error {
	err := p.participationDao.UpdateParticipation(id, key, value)
	if err != nil {
		return err
	}
	return nil
}
func (p participationServiceImpl) DeleteParticipation(id string) error {
	err := p.participationDao.DeleteParticipation(id)
	if err != nil {
		return err
	}
	return nil
}
func (p participationServiceImpl) GetAllResponses(id string) []db.Response {
	responses := p.responseDao.ReadAllResponse(id)
	return responses
}
