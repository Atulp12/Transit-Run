import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  LatLng? _initialPosition;
  Completer<GoogleMapController> controller1 = Completer();
  late GeoPoint currentLocation;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();

    _updateUserLocation();
  }

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location not granted!!');
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _updateUserLocation() {
    /*StreamSubscription stream =*/
    Geolocator.getPositionStream().listen((Position position) async {
      currentLocation = GeoPoint(position.latitude, position.longitude);
      print('location: $currentLocation');
      await db
          .collection('route')
          .doc(auth.currentUser!.uid)
          .update({"Location": currentLocation});
    });

    // stream.cancel();
  }

  void _addMarker() {
    setState(() {
      final newMarker = Marker(
        markerId: MarkerId(currentLocation.toString()),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Marker Snippet',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      markers.add(newMarker);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
        ],
      ),
      body: _initialPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition!,
                    zoom: 14.5,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  // onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: markers,
                ),
              ],
            ),
    );
  }
}
