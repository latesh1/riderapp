import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RiderMapScreen(),
    );
  }
}

class RiderMapScreen extends StatefulWidget {
  const RiderMapScreen({super.key});

  @override
  State<RiderMapScreen> createState() => _RiderMapScreenState();
}

class _RiderMapScreenState extends State<RiderMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  LatLng _center = const LatLng(12.9716, 77.5946); // Default Bangalore
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMapData();
  }

  Future<void> fetchMapData() async {
    try {
      // Replace localhost with your IP if using physical device
      const String baseUrl = 'http://localhost:3000';

      final pickupResponse = await http.get(Uri.parse('$baseUrl/api/pickups'));
      final warehouseResponse =
      await http.get(Uri.parse('$baseUrl/api/warehouse'));

      if (pickupResponse.statusCode == 200 &&
          warehouseResponse.statusCode == 200) {
        final List pickups = jsonDecode(pickupResponse.body);
        final warehouse = jsonDecode(warehouseResponse.body);

        Set<Marker> newMarkers = {};

        // Add warehouse marker
        if (warehouse != null) {
          LatLng warehouseLatLng =
          LatLng(warehouse['lat'], warehouse['lng']);
          newMarkers.add(
            Marker(
              markerId: const MarkerId('warehouse'),
              position: warehouseLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              infoWindow: const InfoWindow(title: 'Warehouse'),
            ),
          );
        }

        // Add pickup markers
        for (var pickup in pickups) {
          LatLng pickupLatLng = LatLng(pickup['lat'], pickup['lng']);
          newMarkers.add(
            Marker(
              markerId: MarkerId('pickup_${pickup['_id']}'),
              position: pickupLatLng,
              infoWindow: InfoWindow(
                title: 'Pickup',
                snippet: '${pickup['time_slot']} - ${pickup['inventory']} items',
              ),
            ),
          );
        }

        setState(() {
          markers = newMarkers;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load map data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Map View'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(target: _center, zoom: 13),
        markers: markers,
      ),
    );
  }
}
