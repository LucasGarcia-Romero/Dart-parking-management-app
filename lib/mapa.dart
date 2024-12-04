import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ParkingRepository.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  final _mapController = Completer<GoogleMapController>();
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(38.757868, -9.153261),
    zoom: 16,
  );

  Set<Marker> _markers = {};
  late BitmapDescriptor _customIcon;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndFetchLocation();
    _fetchParkingLots();
  }

  // Convert widget to BitmapDescriptor
  Future<BitmapDescriptor> _createCustomMarkerIcon() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 60.0;

    // Draw blue filled circle
    final Paint fillPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Ajusta el ancho del borde según sea necesario

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, fillPaint);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, strokePaint);


    final ui.Image image = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  // Request permission and fetch location
  Future<void> _requestPermissionAndFetchLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _customIcon = await _createCustomMarkerIcon();
      setState(() {
        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        );
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
            icon: _customIcon,
            infoWindow: const InfoWindow(title: 'Mi Ubicación'),
          ),
        );
      });
      final controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    } else {
      print('Permisos de ubicación denegados');
    }
  }

  // Fetch parking lots
  Future<void> _fetchParkingLots() async {
    final parkingRepository = ParkingRepository();
    try {
      final parkingLots = await parkingRepository.fetchParkingLots();
      setState(() {
        for (var lot in parkingLots) {
          _markers.add(
            Marker(
              markerId: MarkerId(lot['id_parque']),
              position: LatLng(
                double.parse(lot['latitude']),
                double.parse(lot['longitude']),
              ),
              infoWindow: InfoWindow(
                title: lot['nome'],
                snippet: 'Ocupación: ${lot['ocupacao']}/${lot['capacidade_max']}',
              ),
            ),
          );
        }
      });
    } catch (error) {
      print('Failed to load parking lots: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (controller) {
          _mapController.complete(controller);
        },
        mapType: MapType.normal,
        onTap: (coordenadas) async {
          (await _mapController.future).animateCamera(
            CameraUpdate.newLatLng(coordenadas),
          );
        },
        markers: _markers,
      ),
    );
  }
}
