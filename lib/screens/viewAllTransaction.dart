import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constent/app_size.dart';
import '../widget/transactionCard.dart';

class Viewalltransaction extends StatefulWidget {
  const Viewalltransaction({super.key});

  @override
  State<Viewalltransaction> createState() => _ViewalltransactionState();
}

class _ViewalltransactionState extends State<Viewalltransaction> {
  String searchQuery = ""; // Variable to store the search input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "View All Transactions",
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.fontMedium,
            fontFamily: 'latto',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by Phone Number',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query on input
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contributions')
                    .orderBy('count', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No contributions yet.'));
                  }

                  // Filter documents based on the search query
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final phoneNumber = doc['phoneNumber'] as String;
                    return phoneNumber.contains(searchQuery);
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(child: Text('No contributions found.'));
                  }

                  return ListView(
                    children: filteredDocs.map((doc) {
                      return RefactoredContainer(doc: doc);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
