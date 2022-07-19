import 'package:cloud_firestore/cloud_firestore.dart';

class Driver {
  late final String username;
  late final int totalTrips;
  late final String photoUrl;
  late final String lastTrip;
  late final DateTime createdAt;
  late final String createdBy;
  late final CollectionReference trips;

  Driver({
    required this.username,
    required this.totalTrips,
    required this.lastTrip,
    required this.photoUrl,
    required this.createdAt,
    required this.createdBy,
    required this.trips,
  });

  factory Driver.fromSnapshot(DocumentSnapshot snapshot) {
    return Driver(
        username: snapshot.id,

        totalTrips: snapshot['totalTrips'] ?? 0,

        lastTrip: snapshot['lastTrip'] ?? '',

        photoUrl: snapshot['photoUrl'] ?? 'https://bit.ly/3rFRhWH',

        createdAt: snapshot['createdAt'].toDate(),

        createdBy: snapshot['createdBy'],

        trips: snapshot.reference.collection('trips'),
    );
  }

  static List<Driver> driversFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Driver.fromSnapshot(doc);
    }).toList();
  }
}
