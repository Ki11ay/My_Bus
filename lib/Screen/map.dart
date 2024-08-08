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
  late String id;
  late int num;
  late BitmapDescriptor _busIcon;
  late BitmapDescriptor _busStopIcon;

  final List<String> routeNames = [
    "SALAMIS ROAD",
    "MARAS",
    "EMU BEACH CLUB",
    "MILITARY HOUSES",
    "NICOSIA ROAD"
  ];

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
    ], Colors.green),
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
        id = data['bus_id'];
        num = int.parse(id);
      });
      _updateBusLocation(LatLng(lat, lng));
    });
  }
  void _updateBusLocation(LatLng position) {
    // only show the info of the selected bus route
    // if (num - 1 == _selectedRouteIndex) {
    //   print('object');
    // } else {
    //   print('fail');
    // }
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
    _busIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
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
      print('Error fetching bus stops: $e');
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
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
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
                  // height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                  ),
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
                                              fontSize: 20.0,
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
                              Text(
                                AppLocalizations.of(context)!.currentStation,
                                style: const TextStyle(
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
                              Text(
                                AppLocalizations.of(context)!.nextStation,
                                style: const TextStyle(
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
                              Text(
                                AppLocalizations.of(context)!.estimatedTime,
                                style: const TextStyle(
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
  final List<int> lines;

  BusStop(this.position, this.name, this.lines);
}

class BusRoute {
  final List<LatLng> points;
  final Color color;

  BusRoute(this.points, this.color);
}
