import 'package:cloud_firestore/cloud_firestore.dart';

class BusStation {
  final String id;
  final List<int> lines;
  final GeoPoint loc;
  final String name;

  BusStation({required this.id, required this.lines, required this.loc, required this.name});

  factory BusStation.fromFirestore(DocumentSnapshot doc) {
    return BusStation(
      id: doc['id'],
      lines: List<int>.from(doc['lines']),
      loc: doc['loc'],
      name: doc['name'],
    );
  }
}