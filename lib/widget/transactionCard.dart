import 'package:flutter/material.dart';

class RefactoredContainer extends StatelessWidget {
  final dynamic doc; // Replace with the appropriate data type for doc

  RefactoredContainer({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 61, 65, 101),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLeftSection(doc),
            _buildRightSection(doc),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSection(dynamic doc) {
    return Container(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildText(doc['contributorName'],
              fontWeight: FontWeight.bold, fontSize: 17),
          _buildText(doc['address']),
          _buildPaymentAndDeliveryStatus(doc),
        ],
      ),
    );
  }

  Widget _buildRightSection(dynamic doc) {
    return Container(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildText(doc['count'].toString(),
              fontWeight: FontWeight.bold, fontSize: 17),
          SizedBox(height: 10),
          _buildText('Hadiya'),
        ],
      ),
    );
  }

  Widget _buildText(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontSize = 14}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Poppins-Medium",
        fontWeight: fontWeight,
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }

  Widget _buildPaymentAndDeliveryStatus(dynamic doc) {
    return Row(
      children: [
        _buildStatusText('Payment Status: ', doc['paymentStatus']),
        SizedBox(width: 20),
        _buildStatusText(
            'Delivery: ', doc['isDeliver'] ? 'Delivered' : 'Not Delivered'),
      ],
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
          style: TextStyle(color: Colors.white),
        ),
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
