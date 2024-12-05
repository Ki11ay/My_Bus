import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_bus/components/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late double sh;
  late double sw;
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.1407311, 33.9155663);
  Set<Marker> _markers = {};
  Marker? _busMarker;
  late DatabaseReference _busLocationRef;
  int? _selectedRouteIndex;
  late int people = 0;
  late String next = '';
  late String current = '';
  late String time = '';
  late String id;
  late int num;
  late BitmapDescriptor _busIcon;
  late BitmapDescriptor _busStopIcon;
  List<BusRoute> busRoutes = [];

  @override
  void initState() {
    super.initState();
    _fetchBusStops();
    _loadBusStopIcon();
    _loadBusIcon();
    _fetchBusRoutes();
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
        id = data['bus_id'];
        num = int.parse(id);
      });
      _updateBusLocation(LatLng(lat, lng));
    });
  }

  Future<void> _fetchBusRoutes() async {
    List<BusRoute> result = await _getBusRoutes();
    setState(() {
      busRoutes = result;
    });
  }

  Future<List<BusRoute>> _getBusRoutes() async {
    List<BusRoute> busRoutes1 = [];

    try {
      CollectionReference routes =
          FirebaseFirestore.instance.collection('routes');
      QuerySnapshot querySnapshot = await routes.orderBy('routeId').get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      for (var doc in documents) {
        List<GeoPoint> geoPoints = List<GeoPoint>.from(doc['routeCoordinates']);
        List<LatLng> latLngPoints = geoPoints
            .map((geoPoint) => LatLng(geoPoint.latitude, geoPoint.longitude))
            .toList();

        String routeColorString = doc['routeColor'];
        Color routeColor =
            Color(int.parse(routeColorString.replaceFirst('#', '0xff')));
        String routeName = doc['routeName'];
        String id = doc['routeId'];

        busRoutes1.add(BusRoute(
            latLngPoints, // points
            routeColor, // color
            routeName, // name
            id // id
            ));
      }
    } catch (e) {
      _showError('Error fetching bus routes: $e');
    }

    return busRoutes1;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _updateBusLocation(LatLng position) {
    setState(() {
      _busMarker = Marker(
          onTap: () {
            _selectedRouteIndex = num - 1;
            _showBottomSheet();
          },
          markerId: const MarkerId('bus'),
          position: position,
          icon: _busIcon,
          infoWindow: InfoWindow(title: 'line $id'));
    });
    mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  Future<void> _loadBusIcon() async {
    _busIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40,40)),
      'assets/images/bus.png',
    );
  }

  Future<void> _loadBusStopIcon() async {
    _busStopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/bsustop.png',
    );
  }

  Future<void> _fetchBusStops() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Bus-stations').get();
      final List<BusStop> busStops = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final GeoPoint loc = data['loc'];
        final String name = data['name'];
        final List<int> lines = List<int>.from(data['lines']);
        return BusStop(LatLng(loc.latitude, loc.longitude), name, lines);
      }).toList();

      setState(() {
        _markers = _createMarkers(busStops);
      });
    } catch (e) {
      // print('Error fetching bus stops: $e');
    }
  }

  Set<Marker> _createMarkers(List<BusStop> busStops) {
    return busStops.map((busStop) {
      String linesSnippet = busStop.lines.join(', ');
      return Marker(
          onTap: () {
            setState(() {
              _selectedRouteIndex = busStop.lines.first - 1;
              _showBottomSheet();
            });
            // _buildBusStateIndicator(busStop.lines.first);
          },
          markerId: MarkerId(busStop.position.toString()),
          position: busStop.position,
          infoWindow: InfoWindow(
            title: busStop.name,
            snippet: 'Lines going through this station: $linesSnippet',
          ),
          icon: _busStopIcon);
    }).toSet();
  }

  Set<Polyline> _createPolylines() {
    if (_selectedRouteIndex == null) return {};
    String selectedRouteId = busRoutes[_selectedRouteIndex!].id;
    BusRoute selectedRoute = busRoutes.firstWhere(
        (route) => route.id == selectedRouteId,
        orElse: () => busRoutes.first);

    return {
      Polyline(
        polylineId: PolylineId('route$_selectedRouteIndex'),
        points: selectedRoute.points,
        color: selectedRoute.color,
        width: 5,
      ),
    };
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await Future.delayed(const Duration(seconds: 1)); // Wait for map to render
    setState(() {
      // update or change markers
    });
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
          minChildSize: 0.3,
          expand: false,
          initialChildSize: 0.3,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                ),
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.all(sw * 0.035),
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
                                  borderRadius: BorderRadius.circular(sw * 0.035),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: sw * 0.1,
                                      height: sh * 0.04,
                                      decoration: BoxDecoration(
                                        color: busRoutes[index].color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          busRoutes[index].id,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      busRoutes[index].name,
                                      style: TextStyle(
                                        color: _selectedRouteIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: sw * 0.037,
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
    double seatsize = passengerCount < 35 ? sw * 0.1 : sw * 0.05;
    double standingsize =
        (passengerCount >= 35 && passengerCount < 70) ? sw * 0.1 : 20;
    double fullsize = passengerCount >= 70 ? sw * 0.1 : sw * 0.05;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.airline_seat_recline_normal,
                color: seatedColor,
                size: seatsize,
              ),
              Text(
                AppLocalizations.of(context)!.seated,
                style: TextStyle(color: seatedColor),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Icon(
                Icons.directions_walk_sharp,
                color: standingColor,
                size: standingsize,
              ),
              Text(
                AppLocalizations.of(context)!.standing,
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
                AppLocalizations.of(context)!.full,
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
    sh = MediaQuery.of(context).size.height;
    sw = MediaQuery.of(context).size.width;
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              markers:
                  _busMarker != null ? {..._markers, _busMarker!} : _markers,
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.arrow_back_ios_new,
                                color: primaryColor),
                            Text(
                              AppLocalizations.of(context)!.chooseLine,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            const Icon(Icons.arrow_forward_ios_outlined,
                                color: primaryColor),
                          ],
                        ),
                        const SizedBox(
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(sw * 0.035),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  List.generate(busRoutes.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRouteIndex = index;
                                    });
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
                                      borderRadius: BorderRadius.circular(sw * 0.035),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: sw * 0.1,
                                          height: sh * 0.04,
                                          decoration: BoxDecoration(
                                            color: busRoutes[index].color,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              busRoutes[index].id,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: sw * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          busRoutes[index].name,
                                          style: TextStyle(
                                            color: _selectedRouteIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: sw * 0.037,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          if (_selectedRouteIndex != null) ...[
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.currentStation,
                                  style: TextStyle(
                                      fontSize: sw * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                                current == ''
                                    ? const CircularProgressIndicator.adaptive()
                                    : Text(
                                        current,
                                        style: TextStyle(
                                            fontSize: sw * 0.04,
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.nextStation,
                                  style: TextStyle(
                                      fontSize: sw * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                                next == ''
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        next,
                                        style: TextStyle(
                                            fontSize: sw * 0.04,
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.estimatedTime,
                                  style: TextStyle(
                                      fontSize: sw * 0.04,
                                      fontWeight: FontWeight.bold),
                                ),
                                time == ''
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        time,
                                        style: TextStyle(
                                            fontSize: sw * 0.04,
                                            fontWeight: FontWeight.bold),
                                      )
                              ],
                            ),
                            const Divider(),
                            people == 0
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : _buildBusStateIndicator(people),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BusStop {
  final LatLng position;
  final String name;
  final List<int> lines;

  BusStop(this.position, this.name, this.lines);
}

class BusRoute {
  final List<LatLng> points;
  final Color color;
  final String name;
  final String id;

  BusRoute(this.points, this.color, this.name, this.id);
}
