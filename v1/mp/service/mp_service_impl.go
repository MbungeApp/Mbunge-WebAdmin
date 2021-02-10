package service

import (
	"fmt"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/dao"
	"mbunge-admin/models/db"
	"mbunge-admin/models/request"
	"time"
)

type mpServiceImpl struct {
	mpDao dao.MPDaoInterface
}

func NewMpServiceImpl(client *mongo.Client) MpService {
	return &mpServiceImpl{
		mpDao: dao.NewMPDaoInterface{
			Client: client,
		},
	}
}

func (m mpServiceImpl) ViewAllMps() ([]db.MP, error) {
	mps, err := m.mpDao.ReadAllMp()
	if err != nil {
		return nil, err
	}
	return mps, nil
}

func (m mpServiceImpl) ViewMpById(id string) db.MP {
	mp := m.mpDao.ReadOneMp(id)
	return mp
}

func (m mpServiceImpl) AddMp(mp *request.MpRequest) error {
	layout := "2006-01-02"
	parsedDOB, err := time.Parse(layout, mp.DateOfBirth)

	mpDb := db.MP{
		Name:          mp.Name,
		Image:         mp.Picture,
		Constituency:  mp.Constituency,
		County:        mp.County,
		MartialStatus: mp.MartialStatus,
		DateBirth:     parsedDOB,
		Bio:           mp.Bio,
		Images:        nil,
	}

	err = m.mpDao.CreateMP(mpDb)
	if err != nil {
		return err
	}
	return nil
}

func (m mpServiceImpl) EditMp(id string, mp *request.MpRequest) error {
	layout := "2006-01-02"
	parsedDOB, _ := time.Parse(layout, mp.DateOfBirth)
	originalMp := m.mpDao.ReadOneMp(id)

	if mp.Name != originalMp.Name {
		err := m.mpDao.UpdateMPs(id, "name", mp.Name)
		if err != nil {
			return nil
		}
	} else if mp.Bio != originalMp.Bio {
		err := m.mpDao.UpdateMPs(id, "bio", mp.Bio)
		if err != nil {
			return nil
		}
	} else if parsedDOB != originalMp.DateBirth {
		err := m.mpDao.UpdateMPs(id, "date_birth", mp.DateOfBirth)
		if err != nil {
			return nil
		}
	} else if mp.MartialStatus != originalMp.MartialStatus {
		err := m.mpDao.UpdateMPs(id, "martial_status", mp.MartialStatus)
		if err != nil {
			return nil
		}
	} else if mp.County != originalMp.County {
		err := m.mpDao.UpdateMPs(id, "county", mp.County)
		if err != nil {
			return nil
		}
	} else if mp.Constituency != originalMp.Constituency {
		err := m.mpDao.UpdateMPs(id, "constituency", mp.Constituency)
		if err != nil {
			return nil
		}
	} else if mp.Picture != originalMp.Image {
		err := m.mpDao.UpdateMPs(id, "image", mp.Picture)
		if err != nil {
			return nil
		}
	} else {
		fmt.Println("******************** nothing *******************")
	}
	return nil
}

func (m mpServiceImpl) DeleteMp(id string) error {
	err := m.mpDao.DeleteMPs(id)
	if err != nil {
		return err
	}
	return nil
}

func (m mpServiceImpl) StartLiveSession(agoraId string) error {
	panic("implement me")
}
