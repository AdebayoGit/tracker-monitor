import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


import 'package:viewer/helpers/date.dart';
import 'package:viewer/services/trips_services.dart';

import '../helpers/response.dart';
import '../models/driver.dart';
import '../models/location.dart';
import '../models/trip.dart';
import '../views/records_view/trips_view.dart';
import '../views/records_view/views/completed_trip_info_view.dart';
import '../views/records_view/views/inprogress_trip_info_view.dart';
import '../views/trip_view/components/location_tile.dart';

class TripsController extends GetxController{

  late final TripServices _services;

  late final RxList<Trip> _tripsRepo;

  RxList<Trip> _tripsList = <Trip>[].obs;

  late final RxList<LatLng> progressLocations;

  late final RxList<LocationTile> locationTiles = <LocationTile>[].obs;

  late GoogleMapController mapController;

  @override
  void onInit(){
    _services = TripServices();

    _tripsRepo = <Trip>[].obs;

    super.onInit();
  }

  @override
  void dispose(){
    _tripsRepo.clear();
    _tripsRepo.close();
    super.dispose();
  }

  RxList<Trip> get trips => _tripsList;

  void getDriversTrips({required Driver driver}) {
    _tripsRepo.bindStream(_services.getDriversTrips(driver.trips));
    _tripsList = _tripsRepo.toList().obs;
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

  void filterTrips({required DateTime startDate, DateTime? endDate, bool byTripStartDate = true}) {
    ResponseHelpers.showProgressDialog("Filtering Trips...");
    if(byTripStartDate == true){
      _tripsList.value = _tripsRepo.toList().where((i) => DateHelpers.isBetween(startDate: startDate, endDate: endDate, date: DateHelpers.formatToDateOnly(i.createdAt))).toList();
    } else {
      _tripsList.value = _tripsRepo.toList().where((i) {
        DateTime date = DateHelpers.formatToDateOnly(i.stopPoint!['time'].toDate());
        return DateHelpers.isBetween(startDate: startDate, endDate: endDate, date: date);
      }).toList();
    }
    Get.back();
  }

  Future<void> prepareCompletedTripForViewing({required Trip trip, bool? expandTiles}) async {
    ResponseHelpers.showProgressDialog("Please wait...");

    Set<Marker> tripMarkers = await _createTripMarkers(trip: trip);

    _services.getTripProgress(trip.locations).listen((List<Location> locations) {
      List<LatLng> latLngs = <LatLng>[];

      for(Location location in locations) {
        latLngs.add(location.location);
      }
      latLngs.removeLast();

      LatLngBounds bounds = _computeBounds(latLngs);

      Polyline route = Polyline(
        polylineId: const PolylineId("Route"),
        geodesic: true,
        points: latLngs.toSet().toList(),
        width: 5,
        jointType: JointType.bevel,
        color: Colors.green[900]!,
      );

      Get.back();

      Get.to(() =>
          CompletedTripInfoView(trip: trip, locations: locations, route: route, markers: tripMarkers, bounds: bounds,),
      );
    });
  }

  Future<Widget> _prepareTripForReport({required Trip trip, bool? expandTiles}) async {
    Set<Marker> tripMarkers = await _createTripMarkers(trip: trip);

    List<Location> locations = await _services.getCompletedTripLocations(trip.locations);

    List<LatLng> latLngs = <LatLng>[];

    for(Location location in locations) {
      latLngs.add(location.location);
    }

    LatLngBounds bounds = _computeBounds(latLngs);

    Polyline route = Polyline(
      polylineId: const PolylineId("Route"),
      geodesic: true,
      points: latLngs.toSet().toList(),
      width: 5,
      jointType: JointType.bevel,
      color: Colors.green[900]!,
    );

    return TripInfoReport(trip: trip, locations: locations, route: route, markers: tripMarkers, bounds: bounds,);

  }

  Future<Set<Marker>> _createTripMarkers({required Trip trip, bool expandTiles = false}) async {

    locationTiles.clear();

    Set<Marker> markers = <Marker>{};

    BitmapDescriptor startPin = await _createMarker('assets/images/start_trip_marker.png');

    BitmapDescriptor pausePin = await _createMarker('assets/images/end_trip_marker.png');

    markers.add(Marker(
      markerId: const MarkerId('Start'),
      icon: startPin,
      infoWindow: InfoWindow(title: 'Trip Start', snippet: trip.startPoint['time'].toDate().toString()),
      position: LatLng(trip.startPoint['location'].latitude, trip.startPoint['location'].longitude,),
    ));

    locationTiles.add(LocationTile(initiallyExpanded:expandTiles, press: () => _moveMap(LatLng(trip.startPoint['location'].latitude, trip.startPoint['location'].longitude)), title: "Start Point", time: 'Trip Started ${timeago.format(trip.startPoint['time'].toDate(), allowFromNow: true)}', remark: trip.initialRemarks));

    if(trip.stopPoint != null) {
      BitmapDescriptor endPin = await _createMarker('assets/images/stop_trip_marker.png');

      markers.add(Marker(
        markerId: const MarkerId('End'),
        icon: endPin,
        infoWindow: InfoWindow(title: 'Trip End', snippet: trip.stopPoint!['time'].toDate().toString()),
        position: LatLng(trip.stopPoint!['location'].latitude, trip.stopPoint!['location'].longitude,),
      ));

      locationTiles.add(LocationTile(initiallyExpanded:expandTiles, press: () => _moveMap(LatLng(trip.stopPoint!['location'].latitude, trip.stopPoint!['location'].longitude)), title: "Stop Point", time: 'Trip Ended ${timeago.format(trip.stopPoint!['time'].toDate(), allowFromNow: true)}', remark: 'No remarks provided'));
    }

    int i = 1;

    for(var pause in trip.pauses) {
      markers.add(Marker(
        markerId: MarkerId('Pause $i'),
        icon: pausePin,
        infoWindow: InfoWindow(title: 'Pause $i', snippet: pause['location']['time'].toDate().toString()),
        position: LatLng(pause['location']['location'].latitude, pause['location']['location'].longitude,),
      ));
      locationTiles.add(LocationTile(initiallyExpanded:expandTiles, press: () => _moveMap(LatLng(pause['location']['location'].latitude, pause['location']['location'].longitude)), title: 'Pause $i', time: 'Paused ${timeago.format(pause['location']['time'].toDate(), allowFromNow: true)}', remark: pause['remark'] ));
      i++;
    }

    return markers;
  }

  Future<BitmapDescriptor> _createMarker(String imagePath) {
    ImageConfiguration imageConfiguration =
    createLocalImageConfiguration(Get.context!, size: const Size(2, 2));
    return BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      imagePath,
    ).then((BitmapDescriptor icon) => icon);
  }

  Future<void> _moveMap(LatLng location) async {
    CameraPosition position = CameraPosition(
      target: location,
      zoom: 14.4746,
    );

    mapController.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  LatLngBounds _computeBounds(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      LatLng latlng = list[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  downloadReport() async {
    ResponseHelpers.showProgressDialog("Please wait...");

    final pw.Document pdf = pw.Document();

    for (Trip trip in _tripsList){
      Widget report = await _prepareTripForReport(trip: trip, expandTiles: true);
      /*pdf.addPage(
          pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.SizedBox(child: report); // Center
              }));*/
    }

    Get.back();
  }

}