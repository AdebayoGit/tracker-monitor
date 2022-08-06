import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viewer/controllers/trips_controller.dart';

import '../../../models/location.dart';
import '../../../models/trip.dart';
import '../../../utils/app_theme.dart';
import '../components/trip_text_info_widget.dart';

class TripInfoReport extends GetResponsiveView<TripsController> {
  TripInfoReport({
    Key? key,
    required this.locations,
    required this.trip,
    required this.route,
    required this.markers,
    required this.bounds,
  }) : super(key: key) {
    Get.lazyPut(() => TripsController());
  }

  final List<Location> locations;
  final Set<Marker> markers;
  final Trip trip;
  final Polyline route;
  final LatLngBounds bounds;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: GoogleMap(
                mapType: MapType.normal,
                compassEnabled: false,
                mapToolbarEnabled: false,
                //rotateGesturesEnabled: false,
                //scrollGesturesEnabled: false,
                zoomControlsEnabled: false,
                //zoomGesturesEnabled: false,
                //tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                buildingsEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                  ),
                },
                polylines: {route},
                markers: markers,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController $controller) {
                  _controller.complete($controller);
                  controller.mapController = $controller;
                  $controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)
                  );
                }),
          ),
          Expanded(
            child: ListView(
              children: [
                Text(
                  'TRIP INFO',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle:
                    Theme.of(context).textTheme.headline3!.copyWith(
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.grey[600]!,
                    ),
                  ),
                ),
                Column(
                  children: controller.locationTiles,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
