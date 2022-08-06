import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {

  final double altitude;
  final double direction;
  final DateTime time;
  final LatLng location;
  final double speed;

  Location({
    required this.altitude,
    required this.direction,
    required this.time,
    required this.location,
    required this.speed,
  });

  factory Location.fromSnap(DocumentSnapshot snap){
    return Location(
        altitude: snap['altitude'],
        direction: snap['direction'],
        time: snap['time'].toDate(),
        location: LatLng(snap['location'].latitude, snap['location'].longitude),
        speed: snap['speedInfo']['speed'],
    );
  }

  static List<Location> locationsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Location.fromSnap(doc);
    }).toList();
  }

  static List<LatLng> latLngFromLocation(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Location location = Location.fromSnap(doc);
      return location.location;
    }).toList();
  }
}