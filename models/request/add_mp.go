package request

type MpRequest struct {
	Name          string `json:"name" form:"name"`
	Picture       string `json:"picture" form:"picture"`
	Constituency  string `json:"constituency" form:"constituency"`
	County        string `json:"county" form:"county"`
	MartialStatus string `json:"martial_status" form:"martial_status"`
	DateOfBirth   string `json:"date_of_birth" form:"date_of_birth"`
	Bio           string `json:"bio" form:"bio"`
}
