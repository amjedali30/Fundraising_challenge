import 'dart:async';

import 'package:date_palm_challenge/screens/contribution_screen.dart';
import 'package:flutter/material.dart';

class SpalashScreen extends StatefulWidget {
  const SpalashScreen({super.key});

  @override
  State<SpalashScreen> createState() => _SpalashScreenState();
}

class _SpalashScreenState extends State<SpalashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 150,
              left: 110,
              child: Image.asset(
                "assets/appLogo.jpg",
                width: 200,
              ),
            ),
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
