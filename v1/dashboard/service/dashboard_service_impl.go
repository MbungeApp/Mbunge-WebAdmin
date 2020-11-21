package service

import (
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/dao"
	"mbunge-admin/models/response"
	"mbunge-admin/util"
	"sort"
)

type dashboardServiceImpl struct {
	participationDao dao.ParticipationDaoInterface
	responseDao      dao.ResponseDaoInterface
	//eventsDao        dao.NewsDaoInterface
	usersDao dao.UserDaoInterface
}

// NewDashboardServiceImpl ..
func NewDashboardServiceImpl(client *mongo.Client) DashboardServices {
	partiDao := dao.NewParticipationDaoInterface{
		Client: client,
	}
	resDao := dao.NewResponseDaoInterface{
		Client: client,
	}
	//evenDao := dao.NewEventDaoInterface{
	//	Client: client,
	//}
	userDao := dao.NewUserDaoInterface{Client: client}

	return &dashboardServiceImpl{
		participationDao: partiDao,
		responseDao:      resDao,
		//eventsDao: evenDao ,
		usersDao: userDao,
	}
}
func (d dashboardServiceImpl) GetMetrics() response.Metrics {
	var geoCodeLocations []response.UserLocation
	card := response.Card{
		TotalUsers:         d.usersDao.TotalUsers(),
		TotalParticipation: d.participationDao.TotalParticipations(),
		TotalResponses:     d.responseDao.TotalResponses(),
		TotalEvents:        23, //d.eventsDao.TotalNews(),
	}

	male, female := d.usersDao.GetGenderTotals()
	gender := response.GenderRation{
		Male:   male,
		Female: female,
	}

	userLocations := d.usersDao.UsersLocation()
	for _, element := range userLocations {
		//if contains(geoCodeLocations[], element) {
		//	fmt.Println("**************** todo ***************")
		//} else {
		lat, long := util.LocationToGeoCode(element)
		location := response.UserLocation{
			Name:      element,
			Count:     0,
			Latitude:  lat,
			Longitude: long,
		}

		geoCodeLocations = append(geoCodeLocations, location)
		//	}
	}

	metrics := response.Metrics{
		Card:          card,
		GenderRation:  gender,
		MpOfTheWeek:   response.MpOfTheWeek{},
		UsersLocation: geoCodeLocations,
	}
	return metrics
}

func contains(s []string, searchterm string) bool {
	i := sort.SearchStrings(s, searchterm)
	return i < len(s) && s[i] == searchterm
}
