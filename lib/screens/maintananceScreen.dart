import 'dart:async';

import 'package:date_palm_challenge/widget/splashScreen.dart';
import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Under Maintenance"),
        backgroundColor: Colors.orange, // Customize the app bar color
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 100.0,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                "We're currently performing maintenance on the app. Please try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () {
              //     // Optional: Provide a way for the user to go back or stay updated
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(
              //           content: Text('You can’t proceed at this time.')),
              //     );
              //   },
              //   child: const Text("Go Back"),
              //   style: ElevatedButton.styleFrom(
              //     // primary: Colors.orange, // Button color
              //     textStyle: const TextStyle(
              //       fontSize: 16.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
