import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(35.1407311, 33.9155663);

final List<BusStop> busStops = [
    BusStop(const LatLng(35.131138, 33.917726), 'kaliland'),
    BusStop(const LatLng(35.1321055, 33.9229364), 'Stop 2'),
    BusStop(const LatLng(35.1277599, 33.9224228), 'Gazi'),
    BusStop(const LatLng(35.1261780, 33.9251674), 'Sanayi'),
    BusStop(const LatLng(35.1226413, 33.9320308), 'intercity bus station'),
    BusStop(const LatLng(35.1206592, 33.9361933), 'Baykal'),
    BusStop(const LatLng(35.1193872, 33.9415275), 'NKL'),
    BusStop(const LatLng(35.1125562, 33.9448451), 'Mahkeme'),
    BusStop(const LatLng(35.1036794, 33.9471303), 'Canbulat'),
    BusStop(const LatLng(35.1006281, 33.9453198), 'Maksim'),
    BusStop(const LatLng(35.1006281, 33.9453198), 'Harika Mahallesi'),
    BusStop(const LatLng(35.0985327, 33.9443814), 'Tarlabaşı'),
    BusStop(const LatLng(35.0975237, 33.9425102), 'Çimen Sokak'),
    BusStop(const LatLng(35.0955934, 33.9346812), 'Kurtalan'),
  ];

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

  Set<Marker> _createMarkers() {
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
        markers: _createMarkers(),
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