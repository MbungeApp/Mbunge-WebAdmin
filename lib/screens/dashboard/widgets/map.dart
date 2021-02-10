import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mbungeweb/utils/logger.dart';

class DrawMap extends StatefulWidget {
  @override
  _DrawMapState createState() => _DrawMapState();
}

class _DrawMapState extends State<DrawMap> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // MapboxMapController mapController;

  // List<String> _styleStringLabels = [
  //   "MAPBOX_STREETS",
  //   "SATELLITE",
  //   "LOCAL_ASSET"
  // ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: AnimatedOpacity(
            opacity: 0.7,
            duration: Duration(milliseconds: 700),
            child: Text(
              "User Demography",
              style: theme.textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Card(
          child: SizedBox(
            width: double.infinity,
            height: 650,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                // AppLogger.logVerbose("Map created");
                _controller.complete(controller);
              },
            ),
            // MapboxMap(
            //   accessToken:
            //       "pk.eyJ1IjoiaWFtcGF0byIsImEiOiJja2g0aTBtZWwwNWh6MnhscHphazdxYjJmIn0.YTbOQsa6x1IJ3nLjyAoQ1w",
            //   styleString: _styleStringLabels[0],
            //   initialCameraPosition: CameraPosition(
            //     zoom: 5.55,
            //     target: LatLng(0.0236, 37.9062),
            //   ),
            //   scrollGesturesEnabled: false,
            //   onMapCreated: (MapboxMapController controller) async {
            //     AppLogger.logVerbose("Map created");
            //   },
            // ),
          ),
        ),
      ],
    );
  }

  // Future<LatLng> acquireCurrentLocation() async {
  //   Location location = new Location();

  //   bool serviceEnabled;

  //   PermissionStatus permissionGranted;

  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return null;
  //     }
  //   }
  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return null;
  //     }
  //   }

  //   // Gets the current location of the user
  //   final locationData = await location.getLocation();
  //   return LatLng(locationData.latitude, locationData.longitude);
  // }
}
