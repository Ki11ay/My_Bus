import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bus_stations.dart';
import '../models/assets.dart';
import '../models/notifications.dart';
import '../models/gps_location.dart';

final busStationsProvider = FutureProvider<List<BusStation>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('Bus-stations').get();
  return snapshot.docs.map((doc) => BusStation.fromFirestore(doc)).toList();
});

final assetsProvider = FutureProvider<List<Asset>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('assets').get();
  return snapshot.docs.map((doc) => Asset.fromFirestore(doc)).toList();
});

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('notifications').get();
  return snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList();
});

final gpsLocationsProvider = StreamProvider<List<GpsLocation>>((ref) {
  return FirebaseDatabase.instance.ref('gps_locations').onValue.map((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>;
    return data.values.map((e) => GpsLocation.fromRealtime(e)).toList();
  });
});

final scheduleImageProvider = FutureProvider<String>((ref) async {
  final url = await FirebaseStorage.instance.ref('images/schedule2.png').getDownloadURL();
  return url;
});
