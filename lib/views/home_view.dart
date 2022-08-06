import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viewer/controllers/drivers_controller.dart';

import '../utils/app_theme.dart';
import 'drivers_page_view_coponent.dart';


class Home extends GetResponsiveView<DriversController> {
  Home({Key? key}) : super(key: key){
    Get.lazyPut(() => DriversController());
  }
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() => GoogleMap(
              mapType: MapType.normal,
              markers: controller.markers,
              zoomControlsEnabled: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(9.0820, 8.6753),
                zoom: 5.38,
              ),
              onMapCreated: (GoogleMapController $controller) {
                _controller.complete($controller);
                controller.mapController = $controller;
              },
            ),),
          ),
          DriversPageView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.nearlyWhite,
        tooltip: 'Default Location',
        child: const Icon(Icons.filter_center_focus),
        onPressed: () {
          CameraPosition position = const CameraPosition(
            target: LatLng(9.0820, 8.6753),
            zoom: 5.38,
          );
          controller.mapController.animateCamera(CameraUpdate.newCameraPosition(position));
        },
      ),
    );
  }
}

