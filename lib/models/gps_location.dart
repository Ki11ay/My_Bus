class GpsLocation {
  final String busId;
  final String currentStop;
  final String estimated;
  final double latitude;
  final double longitude;
  final String nextStop;
  final int passengers;

  GpsLocation({
    required this.busId,
    required this.currentStop,
    required this.estimated,
    required this.latitude,
    required this.longitude,
    required this.nextStop,
    required this.passengers,
  });

  factory GpsLocation.fromRealtime(Map<dynamic, dynamic> data) {
    return GpsLocation(
      busId: data['bus_id'],
      currentStop: data['current_stop'],
      estimated: data['estimated'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      nextStop: data['next_stop'],
      passengers: data['passengers'],
    );
  }
}