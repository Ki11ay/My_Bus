import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_bus/components/color.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.1407311, 33.9155663);
  Set<Marker> _markers = {};
  Marker? _busMarker;
  late DatabaseReference _busLocationRef;
  int? _selectedRouteIndex;
  late int people;
  late String next;
  late String current;
  late String time;
  late BitmapDescriptor _busIcon;
  late BitmapDescriptor _busStopIcon;

  final List<String> routeNames = [
    "Lefkosa",
    "Military GuestHouse",
    "Varosha",
    "Salamis"
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

  @override
  void initState() {
    super.initState();
    _fetchBusStops();
    _loadBusStopIcon();
    _loadBusIcon();
    _busLocationRef = FirebaseDatabase.instance.ref().child('gps_locations');
    _busLocationRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final double lat = data['latitude'];
      final double lng = data['longitude'];
      setState(() {
        next = data['next_stop'];
        current = data['current_stop'];
        people = data['passengers'];
        time = data['estimated'];
      });
      _updateBusLocation(LatLng(lat, lng));
    });
  }

  Future<void> _loadBusIcon() async {
    _busIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/bus.png',
    );
  }

  Future<void> _loadBusStopIcon() async {
    _busStopIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bsustop.png',
    );
  }

  void _updateBusLocation(LatLng position) {
    setState(() {
      _busMarker = Marker(
          markerId: const MarkerId('bus'), position: position, icon: _busIcon);
    });
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _fetchBusStops() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Bus-stations').get();
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
            snippet:
                'Bus Stop at ${busStop.position.latitude}, ${busStop.position.longitude}',
          ),
          icon: _busStopIcon);
    }).toSet();
  }

  Set<Polyline> _createPolylines() {
    if (_selectedRouteIndex == null) return {};
    BusRoute selectedRoute = busRoutes[_selectedRouteIndex!];
    return {
      Polyline(
        polylineId: PolylineId('route$_selectedRouteIndex'),
        points: selectedRoute.points,
        color: selectedRoute.color,
        width: 5,
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showBottomSheet() {
    if (_selectedRouteIndex != null) {
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.white,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(busRoutes.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRouteIndex = index;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: _selectedRouteIndex == index
                                      ? primaryColor
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: busRoutes[index].color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      routeNames[index],
                                      style: TextStyle(
                                        color: _selectedRouteIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedRouteIndex != null) ...[],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBusStateIndicator(int passengerCount) {
    Color seatedColor = passengerCount < 35 ? primaryColor : Colors.grey;
    Color standingColor = (passengerCount >= 35 && passengerCount < 70)
        ? primaryColor
        : Colors.grey;
    Color fullColor = passengerCount >= 70 ? primaryColor : Colors.grey;
    double seatsize = passengerCount < 35 ? 35 : 20;
    double standingsize =
        (passengerCount >= 35 && passengerCount < 70) ? 30 : 20;
    double fullsize = passengerCount >= 70 ? 35 : 20;
    return Row(
      children: [
        // Text("people on the bus: $people",style: const TextStyle(
        //   color: primaryColor,
        //   fontWeight: FontWeight.bold
        // ),),
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.event_seat,
                color: seatedColor,
                size: seatsize,
              ),
              Text(
                'seated',
                style: TextStyle(color: seatedColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.directions_walk,
                color: standingColor,
                size: standingsize,
              ),
              Text(
                'standing',
                style: TextStyle(color: standingColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.block,
                size: fullsize,
                color: fullColor,
              ),
              Text(
                'Full',
                style: TextStyle(color: fullColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: _busMarker != null ? {..._markers, _busMarker!} : _markers,
            polylines: _createPolylines(),
          ),
          if (_selectedRouteIndex == null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showBottomSheet,
                child: Container(
                  // height: 30,
                  color: Colors.white,
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Choose the Line",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_selectedRouteIndex != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showBottomSheet,
                child: Container(
                  // height: 200,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(busRoutes.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRouteIndex = index;
                                  });
                                  // Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: _selectedRouteIndex == index
                                        ? primaryColor
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: busRoutes[index].color,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        routeNames[index],
                                        style: TextStyle(
                                          color: _selectedRouteIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_selectedRouteIndex != null) ...[
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Current Station:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                current,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Next Station:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                next,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Estimated time:',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Divider(),
                          _buildBusStateIndicator(people),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
