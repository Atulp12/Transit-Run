// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transit_run_app/resources/network_helper.dart';
import 'package:transit_run_app/utils/colors.dart';

class StudentScreen extends StatefulWidget {
  final String selectedValue;
  static double? studentLat;
  static double? studentLang;
  static double? driverLat;
  static double? driverLang;
  const StudentScreen({
    Key? key,
    required this.selectedValue,
  }) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String userName = '';
  String email = '';
  LatLng? studentLocation;
  LatLng? startLocation;
  GeoPoint? location;
  GeoPoint? updateLocation;
  GoogleMapController? mapController;
  final StreamController streamController = StreamController();
  double? distance;
  double? duration;

  final Set<Polyline> polyLines = {};
  final List<LatLng> polyPoints = [];
  var data;
  var data1;

  _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  void initState() {
    getProfile();
    getCurrentLocation().then((value) {
      setState(() {
        startLocation = value;
      });
    });
    // getDistanceAndTime();

    super.initState();
  }

  @override
  void dispose() {
    mapController!.dispose();
    polyLines.clear();
    super.dispose();
  }

  getData(double startLat, double startLng, double endLat, double endLng) {
    StudentScreen.studentLat = startLat;
    StudentScreen.studentLang = startLng;
    StudentScreen.driverLat = endLat;
    StudentScreen.driverLang = endLng;
    getJsonData(startLat, startLng, endLat, endLng);
  }

  void getJsonData(
      double startLat, double startLng, double endLat, double endLng) async {
  
    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();
      // data1 = await network.calculateDistanceAndTime();
      data1 = await network.calculateDistanceAndTime();

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);
      distance = data['features'][0]['properties']['summary']['distance'];
      duration = data['features'][0]['properties']['summary']['duration'];
      // List<List<double>> distances = data1['distances'];
      // List<List<double>> durations = data1['durations'];
      // distance = distances as double;
      // duration = durations as double;

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }

     
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
        polylineId: const PolylineId("polyline"),
        color: Colors.lightBlue,
        points: polyPoints,
        width: 3);
    polyLines.add(polyline);
    setState(() {});
  }

  Future<LatLng?> getCurrentLocation() async {
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
        studentLocation = LatLng(position.latitude, position.longitude);
      });
    }
    return studentLocation;
  }

  Stream<dynamic> startLocationListener() {
    FirebaseFirestore.instance
        .collectionGroup('route')
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        final docs = querySnapshot.docs.forEach((element) {
          final routeValue = element.get('route');
          if (widget.selectedValue == routeValue) {
            if (change.type == DocumentChangeType.added ||
                change.type == DocumentChangeType.modified) {
              location = element['Location'];
              print(location!.latitude);
              print(location!.longitude);
              streamController.sink.add(location);
              updateChanges(location!.latitude, location!.longitude);
            }
            // updateChanges(location!.latitude, location!.longitude);
          }
        });
      });
    });
    return streamController.stream;
  }

  void updateChanges(double latitude, double longitude) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(latitude, longitude)),
      );
    }
  }

  Future<void> getProfile() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userData = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      userName = userData.get('username');
      email = userData.get('email');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student'),
        actions: [
          TextButton(
              onPressed: () {
                mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                        studentLocation!.latitude, studentLocation!.longitude),
                  ),
                );
              },
              child: const Text(
                'Current',
                style: TextStyle(color: Colors.blue),
              )),
          TextButton(
              onPressed: () {
                mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(location!.latitude, location!.longitude),
                  ),
                );
              },
              child: const Text(
                'Driver',
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
      drawer: Drawer(
        width: 280,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: tealColor),
              accountName: Text(
                userName,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                ),
              ),
              currentAccountPicture:
                  const CircleAvatar(child: Icon(Icons.person)),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: "Poppins", fontSize: 16),
              ),
            ),
            const ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: Text(
                'About us',
                style: TextStyle(fontFamily: "Poppins", fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: studentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: startLocationListener(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // StudentScreen.studentLatitude = studentLocation!.latitude;

                  return Stack(children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target:
                              LatLng(location!.latitude, location!.longitude),
                          zoom: 14.5),
                      onMapCreated: _onMapCreated,
                      // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      polylines: polyLines,
                      markers: {
                        Marker(
                          markerId: const MarkerId('Driver'),
                          icon: BitmapDescriptor.defaultMarker,
                          position:
                              LatLng(location!.latitude, location!.longitude),
                        ),
                      },
                      
                    ),
                    Positioned(
                      bottom: 15,
                      left: 15,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          getData(
                              studentLocation!.latitude,
                              studentLocation!.longitude,
                              location!.latitude,
                              location!.longitude);
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Directions'),
                        style: ElevatedButton.styleFrom(
                            elevation: 3,
                            backgroundColor: tealColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(325, 50)),
                      ),
                    ),
                    duration == null
                        ? Container()
                        : Positioned(
                            right: 2,
                            left: 5,
                            top: 5,
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                  text:
                                      'Total Distance : ${(distance! / 1000).toStringAsFixed(2)} Km\n',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text:
                                      'Total time : ${(duration! / 60).ceil()} min',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ])),
                            ),
                          ),
                  ]);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Driver location is not available for this route!!',
                      overflow: TextOverflow.clip,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 17),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
