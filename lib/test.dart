import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _places = GoogleMapsPlaces(apiKey: 'YOUR_GOOGLE_API_KEY');
  TextEditingController _controller = TextEditingController();
  String _nearestBusStop = '';

  void _searchLocation(String query) async {
    PlacesSearchResponse response = await _places.searchByText(query);
    if (response.results.isNotEmpty) {
      final location = response.results.first.geometry.location;
      final latitude = location.lat;
      final longitude = location.lng;
      _findNearestBusStop(latitude, longitude);
    }
  }

  void _findNearestBusStop(double latitude, double longitude) async {
    CollectionReference busStops = FirebaseFirestore.instance.collection('Bus-stations');

    QuerySnapshot querySnapshot = await busStops.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    QueryDocumentSnapshot? nearestBusStop;
    double nearestDistance = double.infinity;

    for (var doc in documents) {
      GeoPoint busStopLocation = doc['location'];
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
        _nearestBusStop = 'Nearest bus stop: ${nearestBusStop['name']} at ${nearestBusStop['location']}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromARGB(99, 221, 170, 170),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                showCursor: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, size: 30),
                  hintText: 'Enter location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchLocation(_controller.text),
                  ),
                ),
              ),
              if (_nearestBusStop.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _nearestBusStop,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}