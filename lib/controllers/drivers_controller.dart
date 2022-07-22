import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:viewer/controllers/auth_controller.dart';
import 'package:viewer/helpers/response.dart';
import 'package:viewer/models/response_status.dart';
import 'package:viewer/services/drivers_services.dart';

import '../components/capture_image_sheet.dart';
import '../models/driver.dart';
import '../models/trip.dart';
import '../utils/app_theme.dart';
import '../views/records_view/trips_view.dart';

class DriversController extends GetxController {
  late final DriverServices _services;

  final RxList<Driver> _driversList = <Driver>[].obs;

  RxInt driversCount = 0.obs;

  @override
  void onInit() {
    _services = DriverServices();
    _driversList.bindStream(_services.drivers);
    super.onInit();
  }

  List<Driver> get drivers => _driversList;

  Future<void> create({required String username, required String password,
        File? image}) async {
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
      return _driversList.where((i) => i.username.contains(query)).toList();
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
}
