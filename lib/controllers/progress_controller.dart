import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProgressController extends GetxController{

  final RxList<Marker> markers = <Marker>[].obs;

  final List<LatLng> latLngs = <LatLng>[];

  late Rx<Polyline> route;



}