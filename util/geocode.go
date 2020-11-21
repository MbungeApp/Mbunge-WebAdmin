package util

import (
	"fmt"
	mapbox "github.com/ryankurte/go-mapbox/lib"
	"github.com/ryankurte/go-mapbox/lib/geocode"
)

func LocationToGeoCode(location string) (lat float64, long float64) {
	var forwardOpts geocode.ForwardRequestOpts
	forwardOpts.Limit = 1
	mapBox, err := mapbox.NewMapbox("pk.eyJ1IjoiaWFtcGF0byIsImEiOiJja2g0aTBtZWwwNWh6MnhscHphazdxYjJmIn0.YTbOQsa6x1IJ3nLjyAoQ1w")
	if err != nil {
		fmt.Println("Error mapbox: " + err.Error())
	}

	forward, err := mapBox.Geocode.Forward(location, &forwardOpts)
	if err != nil {
		return 0, 0
	}

	if len(forward.Features) > 0 {
		return forward.Features[0].Geometry.Coordinates[0], forward.Features[0].Geometry.Coordinates[1]
	}
	return 0, 0

}
