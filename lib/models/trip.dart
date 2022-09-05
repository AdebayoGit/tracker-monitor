import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  late final String id;

  late final String name;

  late final String status;

  late final String initialRemarks;

  late final DateTime createdAt;

  late final String createdBy;

  late final Map<String, dynamic> startPoint;

  late final List<dynamic> pauses;

  late final Map<String, dynamic>? stopPoint;

  late final DocumentReference ref;

  late final CollectionReference locations;

  Trip({
    required this.id,
    required this.name,
    required this.status,
    required this.initialRemarks,
    required this.createdAt,
    required this.createdBy,
    required this.startPoint,
    required this.pauses,
    required this.stopPoint,
    required this.ref,
    required this.locations,
  });

  factory Trip.fromSnapshot(DocumentSnapshot snap) {
    return Trip(
      id: snap.id,
      name: snap.data().toString().contains('name') ? snap['name'] : snap.id,
      status: snap['status'],
      initialRemarks: snap['initial remarks'] == '' ? 'No remarks provided' : snap['initial remarks'],
      createdAt: DateTime.parse(snap['createdAt']),
      createdBy: snap['createdBy'],
      startPoint: snap['start'],
      pauses: snap['pauses'] ?? [],
      stopPoint: snap['stop'],
      ref: snap.reference,
      locations: snap.reference.collection('locations'),
    );
  }

  static List<Trip> tripsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Trip.fromSnapshot(doc);
    }).toList();
  }
}
