import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    void signOut(){
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Home'),),
      body: Center(child: ElevatedButton(onPressed:signOut , child: const Text('Sign out'))),
    );
  }
}
