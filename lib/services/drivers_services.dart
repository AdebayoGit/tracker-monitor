import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:viewer/services/image_services.dart';

import '../models/driver.dart';
import '../models/location.dart';
import '../models/response_status.dart';
import '../models/trip.dart';

class DriverServices{

  late final FirebaseFunctions _functions;
  late final FirebaseFirestore _store;
  late final CollectionReference ridersRef;
  late final ImageServices _imageServices;

  DriverServices(){
    _functions = FirebaseFunctions.instance;
    _store = FirebaseFirestore.instance;
    ridersRef = _store.collection('riders');
    _imageServices = ImageServices();
  }

  Future<Status> create(String username, String password, String creatorId, File? image) async{
    try {
      String photoUrl = '';
      if(image != null){
        photoUrl = await _imageServices.uploadImage(username: username, image: image).then((value) => value.response as String);
      }
      HttpsCallable callable = _functions.httpsCallable('create');
      return await callable.call(<String, dynamic>{
        'username': username,
        'password': password,
        'photoUrl': photoUrl,
        'creatorId': creatorId,
      }).then((value) => Success(response: "Driver $username created successfully"));
    } on FirebaseFunctionsException catch (e) {
      return Failure(code: e.code, response: e.message as String);
    } catch (e) {
      return Failure(code: e.toString(), response: "Unknown Error");
    }
  }

  Future<Status> delete(String username) async{
    try {
      HttpsCallable callable = _functions.httpsCallable('delete');
      return await callable.call(<String, dynamic>{
        'username': username,
      }).then((value) => Success(response: "Driver $username was deleted successfully"));
    } on FirebaseFunctionsException catch (e) {
      return Failure(code: e.code, response: e.message as String);
    } catch (e) {
      return Failure(code: e.toString(), response: "Unknown Error");
    }
  }
  
  Future<Status> getLastKnownLocation(Driver driver) async {
    try {
      QuerySnapshot snapshot = await driver.trips.doc(driver.lastTrip).collection('locations').orderBy('time').limitToLast(1).get();
      Location location = snapshot.docs.map((doc) {
        return Location.fromSnap(doc);
      }).toList().first;
      return Success(response: location);
    } on Exception catch (e) {
      return Failure(code: e.toString(), response: "Unknown Error");
    }
  }

  Stream<List<Driver>> get drivers {
    return ridersRef.snapshots().map(Driver.driversFromSnapshot);
  }
}