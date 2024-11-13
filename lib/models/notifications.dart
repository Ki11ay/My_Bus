import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String info;
  final Timestamp time;
  final String title;

  NotificationModel({required this.info, required this.time, required this.title});

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    return NotificationModel(
      info: doc['info'],
      time: doc['time'],
      title: doc['title'],
    );
  }
}