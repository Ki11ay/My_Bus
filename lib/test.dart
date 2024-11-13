import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class testscreen extends StatefulWidget {
  const testscreen({super.key});

  @override
  State<testscreen> createState() => _testscreenState();
}

class _testscreenState extends State<testscreen> {
  final storage = FirebaseStorage.instance;
  late String? ScheduleUrl = '';
  late DatabaseReference nextStopRef;
  late String next;
  late String es;

  @override
  void initState() {
    super.initState();
    storage.ref().child('images').listAll().then((value) {
      for (var element in value.items) {
        print(element.fullPath);
      }
    });
    _fetchScheduleUrl();

    nextStopRef = FirebaseDatabase.instance.ref().child('gps_locations');
    nextStopRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        next = data['next_stop'];
        es = data['estimated'];
      });
    });
  }

  Future<void> _fetchScheduleUrl() async {
    try {
      final ref = storage.ref().child('images/schedule2.png');
      final url = await ref.getDownloadURL();
      setState(() {
        ScheduleUrl = url;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          // print('Error fetching schedule url: $e');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('test'),
        ),
        body: Center(
          child: Column(
            children: [
              ScheduleUrl != null
                  ? Image(image: NetworkImage(ScheduleUrl!))
                  : const CircularProgressIndicator(),
              Text(next),
              Text(es),
              // if (next != '' && _selectedBusStop != null) Text(next),
            ],
          ),
        ));
  }
}
