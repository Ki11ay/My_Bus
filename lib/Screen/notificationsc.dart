import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  LatLng _location = Geolocator.getCurrentPosition() as LatLng;
  LatLng? _nearestBusStopLocation;
  String _nearestBusStop = '';

  void _findNearestBusStop(double latitude, double longitude) async {
    CollectionReference busStops =
        FirebaseFirestore.instance.collection('Bus-stations');
    QuerySnapshot querySnapshot = await busStops.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    QueryDocumentSnapshot? nearestBusStop;
    double nearestDistance = double.infinity;
    for (var doc in documents) {
      GeoPoint busStopLocation = doc['loc'];
      double distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        busStopLocation.latitude,
        busStopLocation.longitude,
      );
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestBusStop = doc;
      }
    }
    if (nearestBusStop != null) {
      setState(() {
        _nearestBusStop = 'Nearest bus stop: ${nearestBusStop?['name']}';
        _nearestBusStopLocation = LatLng(
          nearestBusStop?['loc'].latitude,
          nearestBusStop?['loc'].longitude,
        );
      });
    }
  }

  void favbusstop() {
    _findNearestBusStop(_location.latitude, _location.longitude);
  }

  @override
  void initState() {
    super.initState();
    favbusstop();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
