import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_bus/Screen/map.dart';

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
  late BitmapDescriptor _busStopIcon;

  final List<BusRoute> busRoutes = [
  BusRoute([
    const LatLng(35.141695, 33.907058),
    const LatLng(35.1413521, 33.9067915),
    const LatLng(35.1410285, 33.9079375),
    const LatLng(35.1411117, 33.9093016),
    const LatLng(35.1412717, 33.9094250),
    const LatLng(35.1413954, 33.9096082),
    const LatLng(35.1433140, 33.9095636),
    const LatLng(35.1443407, 33.9097638),
    const LatLng(35.1446982, 33.9097567),
    const LatLng(35.1466625, 33.9087918),
    const LatLng(35.1468399, 33.9086567),
    const LatLng(35.1471700, 33.9091063),
    const LatLng(35.1467798, 33.9096380),
    const LatLng(35.1447048, 33.9115474),
    const LatLng(35.1445740, 33.9116215),
    const LatLng(35.1440241, 33.9118810),
    const LatLng(35.1436079, 33.9120819),
    const LatLng(35.1432273, 33.9124228),
    const LatLng(35.1426686, 33.9130186),
    const LatLng(35.1418382, 33.9135849),
    const LatLng(35.1402214, 33.9106284),
    const LatLng(35.1392752, 33.9118492),
    const LatLng(35.1381725, 33.9125942),
    const LatLng(35.1344140, 33.9175090),
    const LatLng(35.1346953, 33.9178785),
    const LatLng(35.1342023, 33.9188270),
    const LatLng(35.1341738, 33.9190177),
    const LatLng(35.1321055, 33.9229364),
    const LatLng(35.1313956, 33.9245639),
    const LatLng(35.1312220, 33.9253331),
    const LatLng(35.1313740, 33.9255536),
    const LatLng(35.1293248, 33.9293013),
    const LatLng(35.1293248, 33.9293013),
    const LatLng(35.1287929, 33.9302468),
    const LatLng(35.1231097, 33.9353698),
    const LatLng(35.1215811, 33.9376591),
    const LatLng(35.120484, 33.938396),
  ], Colors.orange),
  BusRoute([
    const LatLng(35.141695, 33.907058),
    const LatLng(35.1413521, 33.9067915),
    const LatLng(35.1410285, 33.9079375),
    const LatLng(35.1411117, 33.9093016),
    const LatLng(35.1412717, 33.9094250),
    const LatLng(35.1413954, 33.9096082),
    const LatLng(35.1433140, 33.9095636),
    const LatLng(35.1443407, 33.9097638),
    const LatLng(35.1446982, 33.9097567),
    const LatLng(35.1466625, 33.9087918),
    const LatLng(35.1468399, 33.9086567),
    const LatLng(35.1471700, 33.9091063),
    const LatLng(35.1467798, 33.9096380),
    const LatLng(35.1447048, 33.9115474),
    const LatLng(35.1445740, 33.9116215),
    const LatLng(35.1440241, 33.9118810),
    const LatLng(35.1436079, 33.9120819),
    const LatLng(35.1432273, 33.9124228),
    const LatLng(35.1426686, 33.9130186),
    const LatLng(35.1418382, 33.9135849),
    const LatLng(35.1399634, 33.9100977),
    const LatLng(35.1375433, 33.9119763),
    const LatLng(35.1373881, 33.9119079),
    const LatLng(35.1308256, 33.9180729),
    const LatLng(35.1281413, 33.9213475),
    const LatLng(35.1255865, 33.9264658),
    const LatLng(35.1209087, 33.9354221),
    const LatLng(35.1205763, 33.9366184),
    const LatLng(35.1204658, 33.9380882),
    const LatLng(35.1206649, 33.9396389),
    const LatLng(35.1205438, 33.9407558),
    const LatLng(35.1199546, 33.9409475),
    const LatLng(35.1173296, 33.9433755),
    const LatLng(35.1147867, 33.9459771),
    const LatLng(35.1132701, 33.9444796),
    const LatLng(35.1126357, 33.9447049),
    const LatLng(35.1122419, 33.9454459),
    const LatLng(35.1109789, 33.9463773),
    const LatLng(35.1090845, 33.9474153),
  ], Colors.blue),
  BusRoute([
    const LatLng(35.1414035, 33.9129289), 
    const LatLng(35.1402225, 33.9106070),
    const LatLng(35.1410612, 33.9096090),
    const LatLng(35.1413482, 33.9096035),
    const LatLng(35.1432803, 33.9095566),
    const LatLng(35.1445743, 33.9097822),
    const LatLng(35.1466726, 33.9088032),
    const LatLng(35.1468355, 33.9086513),
    const LatLng(35.1473037, 33.9092495),
    const LatLng(35.1475321, 33.9091784),
    const LatLng(35.1481127, 33.9088351),
    const LatLng(35.1483800, 33.9089843),
    const LatLng(35.1487767, 33.9085809),
    const LatLng(35.1496504, 33.9079385),
    const LatLng(35.1546568, 33.9050028),
    const LatLng(35.1576231, 33.9029060),
    const LatLng(35.1619789, 33.9011924),
    const LatLng(35.1648834, 33.8998131),
    const LatLng(35.1650451, 33.9004947),
    const LatLng(35.1653628, 33.9021761),
    const LatLng(35.1654848, 33.9029858),
    const LatLng(35.1657608, 33.9055772),
    const LatLng(35.1668905, 33.9077649),
      ],Colors.green),
  BusRoute([
    const LatLng(35.141695, 33.907058),
    const LatLng(35.1413521, 33.9067915),
    const LatLng(35.1410285, 33.9079375),
    const LatLng(35.1411117, 33.9093016),
    const LatLng(35.1412717, 33.9094250),
    const LatLng(35.1413954, 33.9096082),
    const LatLng(35.1433140, 33.9095636),
    const LatLng(35.1443407, 33.9097638),
    const LatLng(35.1446982, 33.9097567),
    const LatLng(35.1466625, 33.9087918),
    const LatLng(35.1468399, 33.9086567),
    const LatLng(35.1471700, 33.9091063),
    const LatLng(35.1467798, 33.9096380),
    const LatLng(35.1447048, 33.9115474),
    const LatLng(35.1445740, 33.9116215),
    const LatLng(35.1440241, 33.9118810),
    const LatLng(35.1436079, 33.9120819),
    const LatLng(35.1432273, 33.9124228),
    const LatLng(35.1426686, 33.9130186),
    const LatLng(35.1418382, 33.9135849),
    const LatLng(35.1402214, 33.9106284),
    const LatLng(35.1392752, 33.9118492),
    const LatLng(35.1381725, 33.9125942),
    const LatLng(35.1344140, 33.9175090),
    const LatLng(35.1346953, 33.9178785),
    const LatLng(35.1342023, 33.9188270),
    const LatLng(35.1341738, 33.9190177),
    const LatLng(35.1321055, 33.9229364),
    const LatLng(35.1313956, 33.9245639),
    const LatLng(35.1312220, 33.9253331),
    const LatLng(35.1313740, 33.9255536),
    const LatLng(35.1293248, 33.9293013),
    const LatLng(35.1293248, 33.9293013),
    const LatLng(35.1287929, 33.9302468),
    const LatLng(35.1231097, 33.9353698),
    const LatLng(35.1215811, 33.9376591),
    const LatLng(35.120484, 33.938396),
    const LatLng(35.1206589, 33.9396258),
    const LatLng(35.1205089, 33.9414212),
    const LatLng(35.1206175, 33.9441998),
    const LatLng(35.1213615, 33.9463823),
    const LatLng(35.1224539, 33.9484115),
  ], Colors.purpleAccent),
  BusRoute([
    const LatLng(35.141695, 33.907058),
    const LatLng(35.1413521, 33.9067915),
    const LatLng(35.1410285, 33.9079375),
    const LatLng(35.1411117, 33.9093016),
    const LatLng(35.1412717, 33.9094250),
    const LatLng(35.1413954, 33.9096082),
    const LatLng(35.1433140, 33.9095636),
    const LatLng(35.1443407, 33.9097638),
    const LatLng(35.1446982, 33.9097567),
    const LatLng(35.1466625, 33.9087918),
    const LatLng(35.1468399, 33.9086567),
    const LatLng(35.1471700, 33.9091063),
    const LatLng(35.1467798, 33.9096380),
    const LatLng(35.1447048, 33.9115474),
    const LatLng(35.1445740, 33.9116215),
    const LatLng(35.1440241, 33.9118810),
    const LatLng(35.1436079, 33.9120819),
    const LatLng(35.1432273, 33.9124228),
    const LatLng(35.1426686, 33.9130186),
    const LatLng(35.1418382, 33.9135849),
    const LatLng(35.1399634, 33.9100977),
    const LatLng(35.1375433, 33.9119763),
    const LatLng(35.1373881, 33.9119079),
    const LatLng(35.1308256, 33.9180729),
    const LatLng(35.1281413, 33.9213475),
    const LatLng(35.1255865, 33.9264658),
    const LatLng(35.1209087, 33.9354221),
    const LatLng(35.1205763, 33.9366184),
    const LatLng(35.1204658, 33.9380882),
  ], Colors.red),
];

  @override
  void initState() {
    super.initState();
    _loadBusStopIcon();
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterlocname,
                    ),
                    onSubmitted: (_) => _geocode(),
                  ),
                  if (_location != null)
                    Text('Geopoint: (${_location!.latitude}, ${_location!.longitude})'),
                ],
              ),
            ),
            if (_nearestBusStop.isNotEmpty)
              GestureDetector(
                onTap: () {
                  // Handle the press action here
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blueAccent,
                  child: Text(
                    _nearestBusStop,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                polylines: _createPolylines(),
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