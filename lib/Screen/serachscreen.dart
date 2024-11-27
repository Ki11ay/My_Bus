import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  // ignore: unused_field
  late GoogleMapController _mapController;
  late BitmapDescriptor _busStopIcon;
  Set<Polyline> _polylines = {};
  @override
  void initState() {
    super.initState();
    _loadBusStopIcon();
    _fetchBusRoutes();
  }

  Future<void> _fetchBusRoutes() async {
    Set<Polyline> polylines = await _getBusRoutes();
    setState(() {
      _polylines = polylines;
    });
}

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _loadBusStopIcon() async {
    _busStopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bsustop.png',
    );
  }

  Set<Polyline> _createPolylines(List<BusRoute> busRoutes) {
    return busRoutes.asMap().entries.map((entry) {
      int idx = entry.key;
      BusRoute route = entry.value;
      return Polyline(
        polylineId: PolylineId('route$idx'),
        points: route.lines
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
        color: route.color,
        width: 5,
      );
    }).toSet();
  }

  Future<Set<Polyline>> _getBusRoutes() async {
    Set<Polyline> polylines = {};

    try {
      CollectionReference routes = FirebaseFirestore.instance.collection('routes');
      QuerySnapshot querySnapshot = await routes.orderBy('routeId').get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        List<GeoPoint> geoPoints = List<GeoPoint>.from(doc['routeCoordinates']);
        List<LatLng> latLngPoints = geoPoints.map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude)).toList();

        String routeColorString = doc['routeColor'];
        Color routeColor = Color(int.parse(routeColorString.replaceFirst('#', '0xff')));

        Polyline polyline = Polyline(
          polylineId: PolylineId(doc.id),
          points: latLngPoints,
          color: routeColor,
          width: 5,
        );

        polylines.add(polyline);
      }
    } catch (e) {
      _showError('Error fetching bus routes: $e');
    }

    return polylines;
  }

  Future<void> _geocode() async {
    final locationName = "Cyprus Magusa,${_locationController.text}";
    if (locationName.isEmpty) {
      _showError('Please enter a location name.');
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        setState(() {
          _location = LatLng(locations.last.latitude, locations.last.longitude);
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
    CollectionReference busStops =
        FirebaseFirestore.instance.collection('Bus-stations');

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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterlocname,
                    ),
                    onSubmitted: (_) => _geocode(),
                  ),
                ],
              ),
            ),
            if (_nearestBusStop.isNotEmpty)
              GestureDetector(
                onTap: () {
                  // Handle the press action here
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueAccent,
                  child: Text(
                    _nearestBusStop,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                polylines: _polylines,
                myLocationButtonEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _location ?? const LatLng(35.1407311, 33.9155663),
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
                      icon: _busStopIcon,
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

class BusRoute {
  // final List<LatLng> points;
  final Color color;
  final String name;
  final List<GeoPoint> lines;
  final int id;

  BusRoute(this.lines, this.color, this.id, this.name);
}
