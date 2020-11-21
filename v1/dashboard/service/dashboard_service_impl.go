package service

import (
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/dao"
	"mbunge-admin/models/response"
)

type dashboardServiceImpl struct {
	participationDao dao.ParticipationDaoInterface
	responseDao      dao.ResponseDaoInterface
	eventsDao        dao.NewsDaoInterface
	usersDao         dao.UserDaoInterface
}

// NewDashboardServiceImpl ..
func NewDashboardServiceImpl(client *mongo.Client) DashboardServices {
	partiDao := dao.NewParticipationDaoInterface{
		Client: client,
	}
	resDao := dao.NewResponseDaoInterface{
		Client: client,
	}
	return &dashboardServiceImpl{
		participationDao: partiDao,
		responseDao:      resDao,
	}
}
func (d dashboardServiceImpl) GetMetrics() response.Metrics {
	card := response.Card{
		TotalUsers:         d.usersDao.TotalUsers(),
		TotalParticipation: d.participationDao.TotalParticipations(),
		TotalResponses:     d.responseDao.TotalResponses(),
		TotalEvents:        d.eventsDao.TotalNews(),
	}

	male, female := d.usersDao.GetGenderTotals()
	gender := response.GenderRation{
		Male:   male,
		Female: female,
	}

	usersLocations := d.usersDao.UsersLocation()
	metrics := response.Metrics{
		Card:          card,
		MpOfTheWeek:   nil,
		GenderRation:  gender,
		UsersLocation: usersLocations,
	}
	return metrics
}
