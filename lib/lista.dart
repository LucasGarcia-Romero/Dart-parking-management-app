import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'ParkingDetailsScreen.dart';
import 'ParkingRepository.dart';
import 'DatabaseHelper.dart';

class ParkingListPage extends StatefulWidget {
  const ParkingListPage({Key? key}) : super(key: key);

  @override
  _ParkingListPageState createState() => _ParkingListPageState();
}

class _ParkingListPageState extends State<ParkingListPage> {
  List<dynamic> parkingLots = [];
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    fetchData();
    _getCurrentLocation().then((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Future<void> fetchData() async {
    try {
      final parkingRepository = ParkingRepository();
      final fetchedParkingLots = await parkingRepository.fetchParkingLots();
      setState(() {
        parkingLots = fetchedParkingLots;
      });
    } catch (error) {
      throw Exception('Failed to load data: $error');
    }
  }

  // Calculate distance by hand
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radio de la Tierra en kilómetros
    final double dLat = (lat2 - lat1) * math.pi / 180;
    final double dLon = (lon2 - lon1) * math.pi / 180;
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  void _showParkingDetails(BuildContext context, Map<String, dynamic> parkingLot) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParkingDetailsScreen(parkingLot: parkingLot),
        ),
      );
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: parkingLots.length,
        itemBuilder: (BuildContext context, int index) {
          final parkingLot = parkingLots[index];
          final occupiedSpaces = (parkingLot['ocupacao'] as int).clamp(0, parkingLot['capacidade_max']);
          double? distance;

          if (_currentPosition != null) {
            distance = calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              double.parse(parkingLot['latitude']),
              double.parse(parkingLot['longitude']),
            );
          }

          return GestureDetector(
            onTap: () {
              _showParkingDetails(context, parkingLot);
            },
            child: Container(
              width: double.infinity,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${parkingLot['nome']}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '($occupiedSpaces/${parkingLot['capacidade_max']}), ${parkingLot['tipo'] ?? 'Unknown'}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    if (distance != null)
                      Text(
                        'Distance: ${distance.toStringAsFixed(2)} km',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          );
        },
      ),
    );
  }
}
