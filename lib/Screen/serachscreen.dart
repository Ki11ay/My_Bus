import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchScreen extends StatefulWidget {
  // const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _locationController = TextEditingController();
  LatLng? _location;

  Future<void> _geocode() async {
    final locationName = _locationController.text;
    if (locationName.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(locationName);

      if (locations.isNotEmpty) {
        setState(() {
          _location = LatLng(locations.first.latitude, locations.first.longitude);
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
            ],
          ),
        ),
      ),
    );
  }
}