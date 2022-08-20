import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viewer/models/location.dart';

import '../models/trip.dart';
import '../services/trips_services.dart';

class TripReport extends GetxController {
  late final TripServices _services;

  RxSet<Polyline> route = <Polyline>{}.obs;

  RxSet<Marker> markers = <Marker>{}.obs;

  late StreamSubscription<List<Location>> locationStream;

  late StreamSubscription<Trip> tripStream;

  @override
  void onInit(){
    _services = TripServices();

    super.onInit();
  }

  Future<BitmapDescriptor> _createMarker(String imagePath) {
    ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(Get.context!, size: const Size(2, 2));
    return BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      imagePath,
    ).then((BitmapDescriptor icon) => icon);
  }

}