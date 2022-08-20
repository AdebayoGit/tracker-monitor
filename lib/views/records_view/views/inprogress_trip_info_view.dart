import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viewer/controllers/trips_controller.dart';

import '../../../utils/app_theme.dart';

class TripProgressReport extends GetView<TripsController> {
  TripProgressReport({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        centerTitle: true,
        title: const Text(
          'Trip Progress',
          style: TextStyle(letterSpacing: 5, fontFamily: 'WorkSans'),
        ),
        titleSpacing: 2,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
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
                polylines: controller.route,
                markers: controller.markers,
                padding: const EdgeInsets.all(50),
                initialCameraPosition: const CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController $controller) {
                  _controller.complete($controller);
                  controller.mapController = $controller;
                  //controller.moveMap(controller.markers.last.position);
                }),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'TRIP INFO',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      textStyle:
                      Theme.of(Get.context!).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1
                          ..color = Colors.grey[600]!,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.locationTiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return controller.locationTiles[index];
                    },
                  )),
                ),
              ],
            ),
          ),
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

/*DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.9,
              builder: (BuildContext context, ScrollController $controller) {
                return Container(
                  color: Colors.white70,
                  child: ListView(
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
                        controller.locationTiles,
                      ],
                    ),
                );
              }),*/