package service

import (
	"mbunge-admin/models/db"
	"mbunge-admin/models/request"
)

// ParticipationService ..
type ParticipationService interface {
	GetAllParticipations() []db.Participation
	AddParticipation(addParticipation request.PartipationRequest) error
	EditParticipation(id string, key string, value string) error
	DeleteParticipation(id string) error
	GetAllResponses(id string) []db.Response
}
