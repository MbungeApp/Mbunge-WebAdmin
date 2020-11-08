package request

// PartipationRequest ..
type PartipationRequest struct {
	Name     string `json:"name"`
	Sector   string `json:"sector"`
	ExpireAt string `json:"expire_at"`
	PostedBy string `json:"posted_by"`
	Body     string `json:"body" bson:"body"`
}
