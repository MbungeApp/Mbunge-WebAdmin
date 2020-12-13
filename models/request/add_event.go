package request

type EventRequest struct {
	Name    string `json:"name" form:"name"`
	Picture string `json:"picture" form:"picture"`
	Body    string `json:"body" form:"body"`
}
