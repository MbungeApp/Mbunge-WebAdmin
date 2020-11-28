package handler

import (
	"encoding/json"
	"fmt"
	"mbunge-admin/models/request"
	"mbunge-admin/v1/mp/service"
	"net/http"

	"github.com/labstack/echo"
)

type mpHandler struct {
	mpService service.MpService
}

// NewMpHandler ..
func NewMpHandler(e *echo.Echo, mpService service.MpService) {
	mpHandler := &mpHandler{mpService: mpService}
	g := e.Group("/mp")
	g.GET("", mpHandler.getAllMps)
	g.POST("/add", mpHandler.addMp)
	g.GET("/view/:id", mpHandler.getOneMp)
	g.GET("/edit/:id", mpHandler.editMp)
	g.POST("/edit/:id", mpHandler.edit1Mp)
	g.GET("/delete/:id", mpHandler.deleteMp)
}

func (m mpHandler) getAllMps(c echo.Context) error {
	var mpInterface []interface{}
	mpsDb, err := m.mpService.ViewAllMps()
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	marshalMps, err := json.Marshal(mpsDb)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err = json.Unmarshal(marshalMps, &mpInterface)
	return c.Render(http.StatusOK, "mp.html", map[string]interface{}{
		"data": mpInterface,
	})

}

func (m mpHandler) addMp(c echo.Context) error {
	mpReq := new(request.MpRequest)
	if err := c.Bind(mpReq); err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err := m.mpService.AddMp(mpReq)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	return c.Redirect(http.StatusFound, "/mp")
}

func (m mpHandler) getOneMp(c echo.Context) error {
	return nil
}
func (m mpHandler) editMp(c echo.Context) error {
	id := c.Param("id")
	var mpMap interface{}
	mp := m.mpService.ViewMpById(id)

	marshalMp, err := json.Marshal(mp)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err = json.Unmarshal(marshalMp, &mpMap)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}

	return c.Render(http.StatusOK, "mp_edit.html", mpMap)
}
func (m mpHandler) edit1Mp(c echo.Context) error {
	id := c.Param("id")
	mpReq := new(request.MpRequest)
	if err := c.Bind(mpReq); err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	err := m.mpService.EditMp(id, mpReq)
	if err != nil {
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	return c.Redirect(http.StatusFound, "/mp")
}
func (m mpHandler) deleteMp(c echo.Context) error {
	id := c.Param("id")

	err := m.mpService.DeleteMp(id)
	if err != nil {
		fmt.Println("Error deleting: ", err.Error())
		return c.String(http.StatusInternalServerError, "error occurred")
	}
	return c.Redirect(http.StatusFound, "/mp")
}
