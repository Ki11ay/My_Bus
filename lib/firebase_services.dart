import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Notification>> getNotifications() {
    return _db
        .collection('notifications')
        .orderBy('time', descending: false) // Sorting by timestamp
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notification.fromFirestore(doc.data()))
            .toList());
  }

  void printFirstNotification() {
    getNotifications().listen((notifications) {
      if (notifications.isNotEmpty) {
        // print('First Notification: ${notifications.first.info}');
      } else {
        // print('No notifications found.');
      }
    }, onError: (error) {
      // print('Error: $error');
    });
  }
}

class Notification {
  final String info;

  Notification({required this.info});

  factory Notification.fromFirestore(Map<String, dynamic> data) {
    return Notification(
      info: data['info'] ?? 'No info',
    );
  }
}