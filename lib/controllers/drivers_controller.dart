import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:viewer/controllers/auth_controller.dart';
import 'package:viewer/helpers/response.dart';
import 'package:viewer/models/location.dart';
import 'package:viewer/models/response_status.dart';
import 'package:viewer/services/drivers_services.dart';

import '../components/capture_image_sheet.dart';
import '../models/driver.dart';
import '../utils/app_theme.dart';

class DriversController extends GetxController {
  late final DriverServices _services;

  final RxList<Driver> _driversList = <Driver>[].obs;

  final List<Map<String, Location>> driversLastLocations = <Map<String, Location>>[];

  final RxSet<Marker> markers = <Marker>{}.obs;

  RxInt driversCount = 0.obs;

  late GoogleMapController mapController;

  @override
  void onInit() {
    _services = DriverServices();
    _driversList.bindStream(_services.drivers);
    super.onInit();
  }

  @override
  void onReady() async {
    await _getDriversLastLocations();
    super.onReady();
  }

  List<Driver> get drivers => _driversList;

  Future<void> create({required String username, required String password, File? image}) async {
    ResponseHelpers.showProgressDialog("Please wait...");
    AuthController auth = Get.find<AuthController>();
    Status res = await _services.create(username.toLowerCase(), password, auth.user.uid, image);
    Get.back();
    if (res is Success) {
      Get.back();
      ResponseHelpers.showSnackbar(res.response.toString());
    } else {
      ResponseHelpers.showSnackbar(
          "Unable to create Driver $username, ${res.response.toString()}");
    }
  }

  Future<void> delete({required String username}) async {
    ResponseHelpers.showProgressDialog("Please wait...");
    Status res = await _services.delete(username);
    Get.back();
    if (res is Success) {
      Get.back();
      ResponseHelpers.showSnackbar(res.response.toString());
    } else {
      ResponseHelpers.showSnackbar(
          "Unable to delete Driver $username, ${res.response.toString()}");
    }
  }

  List<Driver> searchForDriver({required String query}) {
    if(query.isEmpty){
      return _driversList;
    } else {
      return _driversList.where((i) => i.username.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Future<File?> getCaptureImageSheet() async {
    File? image;
    await Get.bottomSheet(
      CaptureImageSheet(
        onChanged: (File? value) {
          image = value;
          Get.back();
        },
      ),
      backgroundColor: AppTheme.nearlyBlack,
    );
    return image;
  }

  Future<void> _getDriversLastLocations() async {
    if(_driversList.isNotEmpty){
      for (Driver driver in _driversList) {
        if (driver.lastTrip != '') {
          Status res = await _services.getLastKnownLocation(driver.lastTrip);
          if (res is Success) {
            if(res.response == ''){
              ResponseHelpers.showSnackbar("${driver.username}'s last Location is unknown");
            } else {
              Location locationFromResponse = res.response as Location;
              Map<String, Location> location = <String, Location>{driver.username: locationFromResponse};
              markers.add(Marker(
                markerId: MarkerId(driver.username),
                position: locationFromResponse.location,
                rotation: locationFromResponse.direction,
                infoWindow: InfoWindow(title: driver.username),
              ));
              driversLastLocations.add(location);
            }
          } else {
            ResponseHelpers.showSnackbar(
                "Unable to retrieve Driver ${driver.username}'s Location, ${res.response.toString()}");
          }
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 3), () => _getDriversLastLocations());
    }
  }

  //Todo: refactor this controller and Trips controller

  Future<void> moveMap(String username) async {
    late LatLng location;
    for (Map<String, Location> locationObject in driversLastLocations.toList()) {
      for (var entry in locationObject.entries) {
        if(entry.key == username){
          location = entry.value.location;
          CameraPosition position = CameraPosition(
            target: location,
            zoom: 14.4746,
          );

          mapController.animateCamera(CameraUpdate.newCameraPosition(position));

          return;
        }
      }
    }
  }

  BitmapDescriptor _createMarker(String imagePath) {
    ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(Get.context!, size: const Size(2, 2));
    return BitmapDescriptor.defaultMarker;
  }
}
