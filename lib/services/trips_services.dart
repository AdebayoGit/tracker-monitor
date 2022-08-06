import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location.dart';
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
  
  Future<List<Location>> getCompletedTripLocations(CollectionReference ref) async{
    return ref.orderBy('time').get().then((QuerySnapshot value) {
      return Location.locationsFromSnapshot(value);
    });
  }

  Stream<List<Location>> getTripProgress (CollectionReference ref) {
    return ref.orderBy('time').snapshots().map(Location.locationsFromSnapshot);
 }
}