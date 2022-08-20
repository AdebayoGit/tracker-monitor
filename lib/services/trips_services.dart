import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location.dart';
import '../models/trip.dart';

class TripServices{
  late final FirebaseFirestore _store;
  late final CollectionReference _tripsRef;

  TripServices(){
    _store = FirebaseFirestore.instance;
    _tripsRef = _store.collection('trips');
  }

  Stream<List<Trip>> getTrips() {
    return _tripsRef.snapshots().map(Trip.tripsFromSnapshot);
  }

  Stream<Trip> trip (String tripId) {
    return _tripsRef.doc(tripId).snapshots().map(Trip.fromSnapshot);
  }
  
  Future<List<Location>> getCompletedTripLocations(CollectionReference ref) async{
    return ref.orderBy('time').get().then((QuerySnapshot value) {
      return Location.locationsFromSnapshot(value);
    });
  }

  Stream<List<Location>> getTripProgress (CollectionReference ref) {
    return ref.orderBy('time').snapshots().map(Location.locationsFromSnapshot);
 }

  Future<Location?> getLastLocation (String tripId) async {

    try {
      return await _tripsRef.doc(tripId).collection('locations').orderBy('time').limitToLast(1).get().then((value) {
        if(value.docs.isEmpty){
          return null;
        }
        return Location.fromSnap(value.docs.last);
      });
    } on Exception catch (e) {
      return null;
    }
  }

  tripDuration(){

  }
}