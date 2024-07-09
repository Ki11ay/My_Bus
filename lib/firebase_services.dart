import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Notification>> getNotifications() {
    return _db
        .collection('notifications')
        .orderBy('timestamp', descending: false) // Sorting by timestamp
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notification.fromFirestore(doc.data()))
            .toList());
  }
}

class Notification {
  final String message;

  Notification({required this.message});

  factory Notification.fromFirestore(Map<String, dynamic> data) {
    return Notification(
      message: data['info'] ?? '',
    );
  }
}