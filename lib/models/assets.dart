import 'package:cloud_firestore/cloud_firestore.dart';

class Asset {
  final String id;
  final String url;

  Asset({required this.id, required this.url});

  factory Asset.fromFirestore(DocumentSnapshot doc) {
    return Asset(
      id: doc['id'],
      url: doc['url'],
    );
  }
}