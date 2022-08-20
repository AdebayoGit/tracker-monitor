import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viewer/controllers/trips_controller.dart';

import '../../../models/trip.dart';
import '../../../utils/app_theme.dart';

class DynamicTripInfoView extends GetResponsiveView<TripsController> {
  DynamicTripInfoView({
      Key? key,
      required this.trip,
      required this.route,
      required this.markers,
      required this.bounds,
  }) : super(key: key) {
    Get.lazyPut(() => TripsController());
  }

  final Set<Marker> markers;
  final Trip trip;
  final Polyline route;
  final LatLngBounds bounds;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        title: const Text(
          'Trip Info',
          style: TextStyle(letterSpacing: 5, fontFamily: 'WorkSans'),
        ),
        actions: [
          SizedBox(
              height: 45,
              width: 45,
              child: Visibility(
                visible: trip.status == 'completed',
                replacement: const Card(
                  shape: CircleBorder(
                    side: BorderSide(color: AppTheme.colorOrange, width: 2),
                  ),
                  color: AppTheme.primaryColor,
                  shadowColor: AppTheme.primaryLightColor,
                  elevation: 3,
                  child: Icon(
                    Icons.pending,
                    color: AppTheme.colorOrange,
                  ),
                ),
                child: const Card(
                  shape: CircleBorder(
                    side: BorderSide(color: AppTheme.colorGreen, width: 2),
                  ),
                  color: AppTheme.primaryDarkColor,
                  child: Icon(
                      Icons.done_all,
                      color: AppTheme.colorGreen,
                    ),
                ),
              ),
          ),
        ],
        titleSpacing: 2,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
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
              cameraTargetBounds: CameraTargetBounds(bounds),
              padding: const EdgeInsets.all(50),
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
          DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (BuildContext context, ScrollController $controller) {
                return Container(
                  color: Colors.white70,
                  child: Obx(
                    () => ListView(
                      controller: $controller,
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
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        tooltip: 'How-tos',
        child: const Icon(Icons.question_mark),
        onPressed: () {},
      ),
    );
  }
}
