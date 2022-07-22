import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:viewer/services/image_services.dart';

import '../models/driver.dart';
import '../models/response_status.dart';
import '../models/trip.dart';

class TripServices{
  late final FirebaseFirestore _store;
  late final CollectionReference _tripsRef;

  TripServices(){
    _store = FirebaseFirestore.instance;
    _tripsRef = _store.collection('riders');
  }


  Stream<List<Trip>> getDriversTrips(CollectionReference ref) {
    return ref.orderBy('createdAt').snapshots().map(Trip.tripsFromSnapshot);
  }

}