import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContributionModel with ChangeNotifier {
  int _totalContributions = 0;
  final int goal = 2000;

  int get totalContributions => _totalContributions;
  ContributionModel() {
    // Initialize by fetching total contributions
    fetchTotalContributions();

    // Set up a listener for real-time updates
    FirebaseFirestore.instance
        .collection('contributions')
        .snapshots()
        .listen((snapshot) {
      _updateTotalContributions(snapshot);
    });
  }
  void _updateTotalContributions(QuerySnapshot snapshot) {
    _totalContributions = snapshot.docs.fold<int>(
      0,
      (total, doc) => total + (doc['count'] as int),
    );
    notifyListeners();
  }

  Future<void> addContribution(String UserName, String contributerName,
      int count, String mobile, String adr) async {
    // Basic validation for mobile number and address
    if (mobile.isEmpty || adr.isEmpty || count <= 0) {
      throw Exception(
          'Please provide valid mobile number, address, and count.');
    }

    try {
      // Add contribution to Firestore
      await FirebaseFirestore.instance.collection('contributions').add({
        "username": UserName,
        "contributorName": contributerName,
        'timestamp': FieldValue.serverTimestamp(),
        'phoneNumber': mobile,
        'address': adr,
        'count': count,
        'createdAt': FieldValue.serverTimestamp(),
        'paymentStatus': "not paid",
        'isDeliver': "Not Delivered",
        "paymentProof": "",
        "reciptImage": ""
      });

      // Update the total contributions locally
      _totalContributions += count;
      notifyListeners();
    } catch (e) {
      // Handle errors (e.g., show a message to the user)
      print('Error adding contribution: $e');
      throw Exception('Failed to add contribution. Please try again.');
    }
  }

  Future<void> fetchTotalContributions() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('contributions').get();

      _totalContributions = snapshot.docs
          .fold<int>(0, (total, doc) => total + (doc['count'] as int));

      notifyListeners();
    } catch (e) {
      print('Error fetching contributions: $e');
    }
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("QRdetails");
  Stream<QuerySnapshot> getAQR() {
    return collectionReference
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<bool> checkMaintenanceStatusStream() {
    try {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('appStatus');

      // Use snapshots() to get a stream of real-time updates
      return collectionReference.snapshots().map((querySnapshot) {
        // Get the maintenance status from the first document
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs[0]['isMaintenance'] as bool;
        } else {
          return false; // Default to false if no documents found
        }
      });
    } catch (e) {
      print("Error fetching maintenance status: $e");
      return Stream.value(
          false); // Return a stream with a default value (false)
    }
  }
}
