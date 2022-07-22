import 'package:get/get.dart';
import 'package:viewer/services/trips_services.dart';

import '../models/driver.dart';
import '../models/trip.dart';
import '../views/records_view/trips_view.dart';

class TripsController extends GetxController{

  late final TripServices _services;

  late final RxList<Trip> _tripsList;

  late final Driver _driver;

  @override
  void onInit(){
    _services = TripServices();

    _tripsList = <Trip>[].obs;

    super.onInit();
  }

  @override
  void dispose(){
    _tripsList.clear();
    super.dispose();
  }

  List<Trip> get trips => _tripsList;

  void getDriversTrips({required Driver driver}) {
    _driver = driver;
    _tripsList.bindStream(_services.getDriversTrips(driver.trips));
    Get.to(() => TripsView(username: driver.username), transition: Transition.fadeIn, duration: const Duration(seconds: 1));
    return;
  }

  List<Trip> searchForTrip({required String query}) {
    if(query.isEmpty){
      return _tripsList;
    } else {
      return _tripsList.where((i) => i.id.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }
}