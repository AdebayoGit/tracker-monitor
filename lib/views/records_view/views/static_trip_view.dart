import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';


import 'package:viewer/controllers/trips_controller.dart';

import '../../../utils/app_theme.dart';
import '../../trip_view/components/location_tile.dart';

class StaticTripReport extends GetView<TripsController> {
  StaticTripReport({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _completer = Completer();

  late final GoogleMapController _mapController;

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
        titleSpacing: 2,
      ),
      body: Card(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GoogleMap(
                mapType: MapType.normal,
                compassEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                buildingsEnabled: false,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                  ),
                },
                polylines: Get.arguments['route'],
                markers: Get.arguments['markers'],
                initialCameraPosition: Get.arguments['initLocation'],
                onMapCreated: (controller){
                  _mapController = controller;
                  _completer.complete(controller);
                  _mapController.animateCamera(CameraUpdate.newLatLngBounds(Get.arguments['bounds'], 50));
                },
              ),
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: Get.arguments['highlights'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return LocationTile(
                          initiallyExpanded: Get.arguments['highlights'][index]['initiallyExpanded'],
                          press: () {
                            CameraPosition position = CameraPosition(
                              target: Get.arguments['highlights'][index]['latLng'],
                              zoom: 14.4746,
                            );

                            _mapController.animateCamera(CameraUpdate.newCameraPosition(position));
                          },
                          title: Get.arguments['highlights'][index]['title'],
                          time: Get.arguments['highlights'][index]['time'],
                          remark: Get.arguments['highlights'][index]['remark'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
