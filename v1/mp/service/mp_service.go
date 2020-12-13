package service

import (
	"mbunge-admin/models/db"
	"mbunge-admin/models/request"
)

type MpService interface {
	ViewAllMps() ([]db.MP, error)
	ViewMpById(id string) db.MP
	AddMp(mp *request.MpRequest) error
	EditMp(id string, mp *request.MpRequest) error
	DeleteMp(id string) error
	StartLiveSession(agoraId string) error
}
