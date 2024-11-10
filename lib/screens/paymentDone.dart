import 'package:date_palm_challenge/constent/app_size.dart';
import 'package:flutter/material.dart';

import 'contribution_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  PaymentSuccessScreen({Key? key, required this.count}) : super(key: key);
  int count;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Payment Successful'),
      //   centerTitle: true,
      //   backgroundColor: Colors.green,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(
              //   Icons.check_circle_outline,
              //   size: 100,
              //   color: Colors.green,
              // ),
              Image(
                image: AssetImage("assets/done.png"),
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank You for Your Generous Hadiya!',
                style: TextStyle(
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You have successfully contributed ${count} Hadiya',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ContributionScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
