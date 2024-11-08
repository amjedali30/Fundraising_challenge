import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_palm_challenge/constent/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constent/app_size.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;
  String docId;

  TransactionDetailScreen(
      {Key? key, required this.transaction, required this.docId})
      : super(key: key);

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  File? _imageFile; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker(); // Initialize image picker

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.fontMedium,
            fontFamily: 'latto',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contributor: ${widget.transaction['contributorName'].toString().toUpperCase()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Phone Number: ${widget.transaction['phoneNumber']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Address: ${widget.transaction['address']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Count: ${widget.transaction['count']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Total Amount: ${widget.transaction['count']} * 500 = ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '${widget.transaction['count'] * 500}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildStatusText("Payment Status: ",
                        widget.transaction['paymentStatus']),
                    SizedBox(width: 10),
                    if (widget.transaction['paymentStatus'] == "not paid")
                      GestureDetector(
                        onTap: () {
                          _showUploadDialog(context);
                        },
                        child: Icon(
                          Icons.attach_file,
                          color: const Color.fromARGB(255, 243, 33, 61),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Delivery: ${widget.transaction['isDeliver'] == false ? "Pending" : "Delivered"}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusText(String label, String status) {
    Color statusColor;

    if (label == 'Payment Status: ') {
      if (status == "not paid") {
        statusColor = Colors.red;
      } else if (status == "Pending") {
        statusColor = Colors.orange;
      } else {
        statusColor = Colors.green;
      }
    } else {
      statusColor = status == 'Not Delivered' ? Colors.red : Colors.green;
    }

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '${widget.transaction['paymentStatus'] == "not paid" ? "Not Paid" : widget.transaction['paymentStatus'] == "Pending" ? "Pending" : "Paid"}',
          style: TextStyle(fontSize: 16, color: statusColor),
        ),
      ],
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Payment Screenshot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (base64ImageString != null)
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(base64ImageString!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library),
                label: Text('Choose from Gallery'),
              ),
              SizedBox(height: 10),
              // ElevatedButton.icon(
              //   onPressed: () => _pickImage(ImageSource.camera),
              //   icon: Icon(Icons.camera_alt),
              //   label: Text('Take a Photo'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  base64ImageString = null;
                  Navigator.of(context).pop();
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  print(widget.transaction);
                  // Get reference to the document
                  await FirebaseFirestore.instance
                      .collection('contributions')
                      .doc(widget.docId)
                      .update({
                    "paymentProof": base64ImageString,
                    "paymentStatus":
                        "Pending", // Update the paymentStatus to "Pending"
                  });

                  print("Payment Proof and Status updated successfully");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Payment Proof and Status updated successfully"')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Error updating Firestore: $e");
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  String? base64ImageString;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Save the picked image file
      });
      final bytes = await _imageFile!.readAsBytes();
      base64ImageString = base64Encode(bytes);
      print("===========");
      print("=${base64ImageString}");
      Navigator.of(context).pop(); // Close the dialog
      _showUploadDialog(context); // Reopen dialog to show image preview
    }
  }
}
