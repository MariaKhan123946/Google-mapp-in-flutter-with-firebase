import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:project/constant.dart';

class OrdertrackingPagestate extends StatefulWidget {
  const OrdertrackingPagestate({Key? key}) : super(key: key);

  @override
  State<OrdertrackingPagestate> createState() =>
      _OrdertrackingPagestateState();
}

class _OrdertrackingPagestateState extends State<OrdertrackingPagestate> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
      });
    });

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;
      });
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 13.5,
          target: LatLng(
            newLoc.latitude!,
            newLoc.longitude!,
          ),
        ),
      ));
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDUtj7YaEcHu-_QYdmBo14dzX9RaKsa38o",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation(); // Call the method to get current location
    getPolyPoints(); // Call the method to get polyline points
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: currentLocation != null
            ? CameraPosition(
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          zoom: 14.5,
        )
            : CameraPosition(
          target: LatLng(0, 0),
          zoom: 14.5,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: primaryColor,
            width: 6,
          )
        },
        markers: {
          if (currentLocation != null)
            Marker(
              markerId: MarkerId("currentlocation"),
              position: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
            ),
          Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: destination,
          ),
        },
      ),
    );
  }
}
