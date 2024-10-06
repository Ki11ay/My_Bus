import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';

class AddBusStopPage extends StatefulWidget {
  @override
  _AddBusStopPageState createState() => _AddBusStopPageState();
}

class _AddBusStopPageState extends State<AddBusStopPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController linesController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final geo = Geoflutterfire();

  void addBusStop() async {
    String id = idController.text;
    double lat = double.parse(latController.text);
    double lon = double.parse(lonController.text);
    String name = nameController.text;
    List<int> lines = linesController.text.split(',').map((s) => int.parse(s.trim())).toList();

    final loc = GeoPoint(lat, lon);

    await firestore.runTransaction((transaction) async {
      final busStationsRef = firestore.collection('Bus-stations');

      // Check for existing bus stop with the same ID
      final querySnapshot = await busStationsRef.where('id', isEqualTo: id).get();
      final existingIds = querySnapshot.docs.map((doc) => doc['id'] as String).toList();

      if (existingIds.isNotEmpty) {
        // Find bus stops with the same first character and order by 'id' descending
        final sameFirstCharQuery = await busStationsRef
            .where('id', isGreaterThanOrEqualTo: id[0])
            .where('id', isLessThan: String.fromCharCode(id.codeUnitAt(0) + 1))
            .orderBy('id', descending: true)
            .get();

        for (final doc in sameFirstCharQuery.docs) {
          final oldId = doc['id'] as String;
          if (oldId.compareTo(id) >= 0) {
            final newIdNumber = int.parse(oldId.substring(1)) + 1;
            final newId = '${oldId[0]}$newIdNumber';
            transaction.update(doc.reference, {'id': newId});
          }
        }
      }

      // Add the new bus stop
      transaction.set(busStationsRef.doc(), {
        'id': id,
        'loc': loc,
        'name': name,
        'lines': lines,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bus stop added successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Stop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: latController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lonController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: linesController,
              decoration: InputDecoration(labelText: 'Lines (comma-separated)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addBusStop,
              child: Text('Add Bus Stop'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddBusStopPage(),
  ));
}