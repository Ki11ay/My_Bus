import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

class DataProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _realtimeDatabase = FirebaseDatabase.instance.ref();

  Map<String, dynamic> busStations = {};
  Map<String, dynamic> assets = {};
  Map<String, dynamic> notifications = {};
  Map<String, dynamic> gpsLocations = {};

  Future<void> fetchInitialData() async {
    try {
      // Fetch Bus Stations data
      QuerySnapshot busStationsSnapshot = await _firestore.collection('Bus-stations').get();
      busStations = {for (var doc in busStationsSnapshot.docs) doc.id: doc.data()};

      // Fetch Assets data
      QuerySnapshot assetsSnapshot = await _firestore.collection('assets').get();
      assets = {for (var doc in assetsSnapshot.docs) doc.id: doc.data()};

      // Fetch Notifications data
      QuerySnapshot notificationsSnapshot = await _firestore.collection('notifications').get();
      notifications = {for (var doc in notificationsSnapshot.docs) doc.id: doc.data()};

      // Fetch GPS Locations from Realtime Database
      DatabaseEvent gpsSnapshot = await _realtimeDatabase.child('gps_locations').once();
      gpsLocations = gpsSnapshot.snapshot.value as Map<String, dynamic>;

      // Notify listeners that data is ready
      notifyListeners();
    } catch (e) {
      // print("Error fetching data: $e");
    }
  }
}