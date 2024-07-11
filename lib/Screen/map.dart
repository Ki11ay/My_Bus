import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.1407311, 33.9155663);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchBusStops();
  }

  Future<void> _fetchBusStops() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Bus-stations').get();
      final List<BusStop> busStops = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final GeoPoint loc = data['loc'];
        final String name = data['name'];
        return BusStop(LatLng(loc.latitude, loc.longitude), name);
      }).toList();

      setState(() {
        _markers = _createMarkers(busStops);
      });
    } catch (e) {
      print('Error fetching bus stops: $e');
    }
  }

  Set<Marker> _createMarkers(List<BusStop> busStops) {
    return busStops.map((busStop) {
      return Marker(
        markerId: MarkerId(busStop.position.toString()),
        position: busStop.position,
        infoWindow: InfoWindow(
          title: busStop.name,
          snippet: 'Bus Stop at ${busStop.position.latitude}, ${busStop.position.longitude}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toSet();
  }

  Set<Polyline> _createPolylines() {
    final List<BusRoute> busRoutes = [
      BusRoute([
        const LatLng(35.141695, 33.907058),
        const LatLng(35.131138, 33.917726),
        const LatLng(35.127284, 33.923281),
        const LatLng(35.120484, 33.938396),
      ], Colors.red),
      BusRoute([
        const LatLng(35.141695, 33.907058),
        const LatLng(35.1403, 33.9130),
        const LatLng(35.1417, 33.9145),
      ], Colors.purpleAccent),
      BusRoute([
        const LatLng(35.141695, 33.907058),
        const LatLng(35.1421, 33.9152),
        const LatLng(35.1425, 33.9165),
      ], Colors.blue),
      BusRoute([
        const LatLng(35.141695, 33.907058),
        const LatLng(35.1321055, 33.9229364),
        const LatLng(35.1313740, 33.9255536),
        const LatLng(35.1293248, 33.9293013),
        const LatLng(35.120484, 33.938396),
      ], Colors.orange),
    ];

    return busRoutes.asMap().entries.map((entry) {
      int idx = entry.key;
      BusRoute route = entry.value;
      return Polyline(
        polylineId: PolylineId('route$idx'),
        points: route.points,
        color: route.color,
        width: 5,
      );
    }).toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers,
        polylines: _createPolylines(),
      ),
    );
  }
}

class BusStop {
  final LatLng position;
  final String name;

  BusStop(this.position, this.name);
}

class BusRoute {
  final List<LatLng> points;
  final Color color;

  BusRoute(this.points, this.color);
}