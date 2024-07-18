import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


Future<void> addRoute({
  required List<GeoPoint> points,
  required String color,
  required int id,
  required List<String> busStations,
  required String name,
}) async {
  try {
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Creating a document in the 'Routes' collection
    await firestore.collection('Routes').add({
      'points': [
      const LatLng(35.141695, 33.907058),
      const LatLng(35.1413521, 33.9067915),
      const LatLng(35.1410285, 33.9079375),
      const LatLng(35.1411117, 33.9093016),
      const LatLng(35.1412717, 33.9094250),
      const LatLng(35.1413954, 33.9096082),
      const LatLng(35.1433140, 33.9095636),
      const LatLng(35.1443407, 33.9097638),
      const LatLng(35.1446982, 33.9097567),
      const LatLng(35.1466625, 33.9087918),
      const LatLng(35.1468399, 33.9086567),
      const LatLng(35.1471700, 33.9091063),
      const LatLng(35.1467798, 33.9096380),
      const LatLng(35.1447048, 33.9115474),
      const LatLng(35.1445740, 33.9116215),
      const LatLng(35.1440241, 33.9118810),
      const LatLng(35.1436079, 33.9120819),
      const LatLng(35.1432273, 33.9124228),
      const LatLng(35.1426686, 33.9130186),
      const LatLng(35.1418382, 33.9135849),
      const LatLng(35.1402214, 33.9106284),
      const LatLng(35.1392752, 33.9118492),
      const LatLng(35.1381725, 33.9125942),
      const LatLng(35.1344140, 33.9175090),
      const LatLng(35.1346953, 33.9178785),
      const LatLng(35.1342023, 33.9188270),
      const LatLng(35.1341738, 33.9190177),
      const LatLng(35.1321055, 33.9229364),
      const LatLng(35.1313956, 33.9245639),
      const LatLng(35.1312220, 33.9253331),
      const LatLng(35.1313740, 33.9255536),
      const LatLng(35.1293248, 33.9293013),
      const LatLng(35.1293248, 33.9293013),
      const LatLng(35.1287929, 33.9302468),
      const LatLng(35.1231097, 33.9353698),
      const LatLng(35.1215811, 33.9376591),
      const LatLng(35.120484, 33.938396),
    ],
      'color': "orange",
      'id': 1,
      'bus_stations': ["uni bus station","registeration","civil","main gate","library","M/Sa Arena Durağı","Yeni İzmir","Dumlupinar","anit"],
      'name': "Salamis",
    });

    print('Route added successfully');
  } catch (e) {
    print('Failed to add route: $e');
  }
}