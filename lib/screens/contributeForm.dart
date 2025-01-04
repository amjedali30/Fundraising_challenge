import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constent/app_colors.dart';
import '../constent/app_responsive_size.dart';
import '../constent/app_size.dart';
import '../models/contribution_model.dart';
import 'paymentDone.dart';

class ContributeForm extends StatefulWidget {
  ContributeForm({super.key, required this.username, required this.mobile});
  final String username;
  String mobile;

  @override
  State<ContributeForm> createState() => _ContributeFormState();
}

class _ContributeFormState extends State<ContributeForm> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _otherNameController = TextEditingController();

  int selectedContribution = 0;
  bool isSelect = false;
  bool isSelf = true; // true for Self, false for Someone Else
  double totalAmt = 0;
  void _updateContribution(int value) {
    setState(() {
      selectedContribution = value;
      _controller.text = selectedContribution.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final AppResponsiveSizes responsiveSizes = AppResponsiveSizes(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Participating Now",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.fontMedium,
            color: AppColors.buttonColor1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background image filling the screen, rotated upside down
              Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Transform.rotate(
                    angle: 3.14159, // 180 degrees in radians
                    child: Image.asset(
                      'assets/bg1.jpeg', // Replace with your image asset

                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.005,
                left: 0,
                right: 0,
                child: Container(
                    width: double.infinity,
                    height: 200,
                    // color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('banner')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child:
                                    CircularProgressIndicator(), // Show loading spinner while fetching data
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Icon(Icons
                                      .error)); // Show error icon if there's an error
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Image.asset(
                                  "assets/banner2.png", // Default image if no banners found
                                  fit: BoxFit.fill,
                                ),
                              );
                            }

                            // Extract the first banner URL
                            String bnrUrl = snapshot.data!.docs[0]["ban2"] ??
                                ""; // Ensure ban2 is not null

                            // If bnrUrl is empty, show the default image
                            if (bnrUrl.isNotEmpty) {
                              return Image.network(
                                bnrUrl,
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image has loaded
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ), // Show loading indicator while the image is loading
                                    );
                                  }
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Image.asset(
                                      "assets/banner2.png", // Default image if no banners found
                                      fit: BoxFit.fill,
                                    ),
                                  ); // Show error icon if image fails to load
                                },
                              );
                            } else {
                              return Image.asset(
                                "assets/banner2.png", // Default fallback image if bnrUrl is empty
                                fit: BoxFit.fill,
                              );
                            }
                          },
                        ),
                      ),
                    )

                    //  Image(
                    //   image: AssetImage("assets/image1.png"),
                    //   fit: BoxFit.contain,
                    // ),
                    ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.23,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Contribute",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontLarge,
                            color: AppColors.buttonColor1,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "1 Hadiya : 500 INR",
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 8.0,
                          children: [2, 3, 5, 10].map((amount) {
                            return ChoiceChip(
                              label: Text(
                                '$amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontMedium,
                                  color: AppColors.buttonColor1,
                                ),
                              ),
                              selected: selectedContribution == amount,
                              onSelected: (isSelected) {
                                if (isSelected) _updateContribution(amount);
                                totalAmt = (amount) * 500;
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Custom Hadiya',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              selectedContribution = int.tryParse(value) ?? 0;
                              totalAmt = (int.tryParse(value) ?? 0) * 500;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Total Amount :",
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              totalAmt.toString(),
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Enter Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20),
                        // Selection for self or someone else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text('Self'),
                                value: true,
                                groupValue: isSelf,
                                onChanged: (value) {
                                  setState(() {
                                    isSelf = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text('For Others'),
                                value: false,
                                groupValue: isSelf,
                                onChanged: (value) {
                                  setState(() {
                                    isSelf = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        if (!isSelf)
                          TextField(
                            controller: _otherNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor1,
                            shape: const StadiumBorder(),
                            fixedSize: Size(
                              responsiveSizes.dynamicWidth(55),
                              responsiveSizes.dynamicHeight(2),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isSelect = true;
                            });
                            if (isSelect) {
                              _submit();
                            }
                          },
                          child: Text(
                            isSelect
                                ? "Adding Contribution..."
                                : 'Add Contribution',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.fontSmall,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submit() {
    final int amount = int.tryParse(_controller.text) ?? 0;
    final String mobile = _phoneController.text.trim();
    final String address = _addressController.text.trim();
    final String contributorName =
        isSelf ? widget.username : _otherNameController.text.trim();

    final contributionModel =
        Provider.of<ContributionModel>(context, listen: false);

    if (contributionModel.totalContributions + amount >
        contributionModel.goal) {
      setState(() {
        isSelect = false;
      });
      _showDialog(
          'Goal Exceeded', 'Cannot add contribution as it exceeds the goal.');
    } else if (amount > 0 &&
        mobile.isNotEmpty &&
        address.isNotEmpty &&
        (isSelf || contributorName.isNotEmpty)) {
      contributionModel
          .addContribution(
              widget.username, contributorName, amount, mobile, address)
          .then((_) {
        if (!isSelf) _otherNameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contribution added successfully.')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(
                      count: amount,
                    )));

        _controller.clear();
        _addressController.clear();
      }).catchError((error) {
        setState(() {
          isSelect = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    } else {
      setState(() {
        isSelect = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly.')),
      );
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
