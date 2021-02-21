import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbungeweb/models/metrics.dart';

class DrawMap extends StatefulWidget {
  final List<UsersLocation> location;

  const DrawMap({Key key, @required this.location}) : super(key: key);
  @override
  _DrawMapState createState() => _DrawMapState();
}

class _DrawMapState extends State<DrawMap> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 1;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.0236, 37.9062),
    zoom: 7.0,
  );
  List<UsersLocation> get _location => widget.location;

  void _add(
    LatLng latLng,
    String name,
  ) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: "Name: $name", snippet: '*'),
      onTap: () {},
      onDragEnd: (LatLng position) {},
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

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
            height: 720,
            child: GoogleMap(
              zoomGesturesEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                debugPrint("######### add markers ############");
                if (_location.isNotEmpty || _location != null) {
                  _location.forEach((loc) {
                    // LatLng latLng = LatLng(loc.latitude, loc.longitude);
                    LatLng latLng = LatLng(loc.longitude, loc.latitude);

                    _add(
                      latLng,
                      loc.name,
                    );
                  });
                }
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
