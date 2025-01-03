library;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ATMMapPage extends StatefulWidget {
  const ATMMapPage({super.key});

  @override
  ATMMapPageState createState() => ATMMapPageState();
}

class ATMMapPageState extends State<ATMMapPage> {
  late GoogleMapController _mapController;

  final List<LatLng> atmLocations = [
    const LatLng(43.4643, -80.5204), // Waterloo City Center
    const LatLng(43.4668, -80.5222), // University of Waterloo
    const LatLng(43.4503, -80.5255), // Wilfrid Laurier University
    const LatLng(43.4743, -80.5438), // RIM Park
    const LatLng(43.4621, -80.4955), // Bechtel Park
    const LatLng(43.4535, -80.4920), // Conestoga Mall
    const LatLng(43.4823, -80.5442), // Grey Silo Golf Club
    const LatLng(43.4750, -80.5127), // Laurel Creek Conservation Area
    const LatLng(43.4617, -80.5209), // Bauer Marketplace
    const LatLng(43.4562, -80.5075), // Waterloo Public Library
  ];

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initalizeMarkers();
  }

    void _initalizeMarkers(){
    for (int i = 0; i < atmLocations.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('atm_$i'),
          position: atmLocations[i],
          infoWindow: InfoWindow(
            title: 'ATM ${i + 1}',
            snippet: 'Location ${i + 1}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATM Locations'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(43.4643, -80.5204), 
          zoom: 13, 
        ),
        markers: _markers,
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }

  @override
  void dispose(){
    _mapController.dispose();
    super.dispose();
  }
}

