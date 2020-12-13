package request

// PartipationRequest ..
type PartipationRequest struct {
	Name     string `json:"name" form:"name"`
	Sector   string `json:"sector" form:"sector"`
	ExpireAt string `json:"expire_at" form:"expire_at"`
	PostedBy string `json:"posted_by" form:"posted_by"`
	Body     string `json:"body" bson:"body" form:"body"`
}
