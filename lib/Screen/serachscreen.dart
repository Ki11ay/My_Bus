import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _nearestBusStop = '';
  final TextEditingController _locationController = TextEditingController();
  LatLng? _location;
  LatLng? _nearestBusStopLocation;
  late GoogleMapController _mapController;

  Future<void> _geocode() async {
    final locationName = _locationController.text;
    if (locationName.isEmpty) {
      _showError('Please enter a location name.');
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        setState(() {
          _location = LatLng(locations.first.latitude, locations.first.longitude);
        });
        _findNearestBusStop(_location!.latitude, _location!.longitude);
      } else {
        _showError('Could not find any result for the supplied address.');
      }
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _findNearestBusStop(double latitude, double longitude) async {
    CollectionReference busStops = FirebaseFirestore.instance.collection('Bus-stations');

    QuerySnapshot querySnapshot = await busStops.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    QueryDocumentSnapshot? nearestBusStop;
    double nearestDistance = double.infinity;

    for (var doc in documents) {
      GeoPoint busStopLocation = doc['loc'];
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
        _nearestBusStop = 'Nearest bus stop: ${nearestBusStop?['name']}';
        _nearestBusStopLocation = LatLng(
          nearestBusStop?['loc'].latitude,
          nearestBusStop?['loc'].longitude,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Location Name',
                    ),
                    onSubmitted: (_) => _geocode(),
                  ),
                  ElevatedButton(
                    onPressed: _geocode,
                    child: const Text('Submit'),
                  ),
                  if (_location != null)
                    Text('Geopoint: (${_location!.latitude}, ${_location!.longitude})'),
                  if (_nearestBusStop.isNotEmpty)
                    Text(_nearestBusStop),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _location ?? const LatLng(0, 0),
                  zoom: 14,
                ),
                markers: {
                  if (_location != null)
                    Marker(
                      markerId: const MarkerId('searchedLocation'),
                      position: _location!,
                      infoWindow: const InfoWindow(title: 'Searched Location'),
                    ),
                  if (_nearestBusStopLocation != null)
                    Marker(
                      markerId: const MarkerId('nearestBusStop'),
                      position: _nearestBusStopLocation!,
                      infoWindow: InfoWindow(title: _nearestBusStop),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      )
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}