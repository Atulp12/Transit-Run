// ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transit_run_app/screens/driver_screen.dart';
import 'package:transit_run_app/screens/home_screen.dart';
import 'package:transit_run_app/screens/student_screen.dart';

import '../utils/colors.dart';

class RouteContainer extends StatefulWidget {
  const RouteContainer({super.key});

  @override
  State<RouteContainer> createState() => _RouteContainerState();
}

class _RouteContainerState extends State<RouteContainer> {
  List<String> items = ["Route No.1", "Route No.2", "Route No.3"];
  var selectedValue = '';

  void onPressed() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot docs) {
      final data = docs.data() as Map<String, dynamic>;
      final role = data['usertype'] as String;
      if (role == 'Student') {
        return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: ((context) =>  StudentScreen(
                      selectedValue : selectedValue
                    ))),
            (route) => false);
      } else if (role == 'Driver') {
        _firestore
            .collection("route")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'route': selectedValue
        });

        return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => const DriverScreen())),
            (route) => false);
      } else if (role == 'Admin') {
        return Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => const HomeScreen())),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 350,
          height: 300,
          child: Card(
            color: const Color.fromARGB(255, 45, 47, 61),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Select your route ",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonFormField(
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                    value: items[0],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: Divider.createBorderSide(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                    ),
                    items: items.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (dynamic newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select a route" : null,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tealColor,
                    minimumSize: const Size(200, 50),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
