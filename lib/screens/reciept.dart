import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  final String username;
  final String userPhotoUrl; // URL for user's photo
  final int contributionCount;

  ReceiptScreen(
      {required this.username,
      required this.userPhotoUrl,
      required this.contributionCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Photo
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        userPhotoUrl,
                        width: constraints.maxWidth * 0.3, // Responsive width
                        height: constraints.maxWidth * 0.3, // Responsive height
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // User Name
                  Center(
                    child: Text(
                      username,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Contribution Count
                  Center(
                    child: Text(
                      'Contribution Count: $contributionCount',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Other details can be added here...
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Thank you for your contribution!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
