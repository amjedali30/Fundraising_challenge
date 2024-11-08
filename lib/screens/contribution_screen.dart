import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constent/app_colors.dart';
import '../constent/app_responsive_size.dart';
import '../constent/app_size.dart';
import '../models/contribution_model.dart';
import '../widget/transactionCard.dart';
import 'contributeForm.dart';
import 'loginScreen.dart';
import 'profile.dart';
import 'viewAllTransaction.dart';

class ContributionScreen extends StatefulWidget {
  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  String? username;
  String? phoneNumber;
  int selectedContribution = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      phoneNumber = prefs.getString('phoneNumber');
      // _phoneController.text = phoneNumber.toString();
    });
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final AppResponsiveSizes responsiveSizes = AppResponsiveSizes(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width *
            .5, // Adjust width to fit the icon and text
        child: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            if (username != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContributeForm(
                            username: username!,
                            mobile: phoneNumber!,
                          )));
            } else {
              _showDialog('Not Logged In',
                  'You must be logged in to add a contribution.');
            }
          },
          shape: StadiumBorder(),
          backgroundColor: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center icon and text
            children: [
              Icon(
                FontAwesomeIcons.coins,
                color: Color.fromARGB(255, 251, 203, 60),
              ),
              SizedBox(width: 15), // Space between icon and text
              Text(
                "Participate Now",
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'ഈത്തപ്പഴ ചലഞ്ച്',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.fontLarge,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (username != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              username: username!,
                              mobileNo: phoneNumber!,
                            )));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            },
            child: CircleAvatar(
              child: Icon(Icons.face),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (username != null)
                Text(
                  "Hi , ${username}",
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    fontSize: 17,
                  ),
                ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/bnr1.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Progress",
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 5),
              Consumer<ContributionModel>(
                builder: (context, model, child) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 61, 65, 101),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.buttonColor2,
                                    radius: 25,
                                    child: Icon(
                                      FontAwesomeIcons.donate,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LinearPercentIndicator(
                                        width: 280,
                                        lineHeight: 10.0,
                                        percent: model.totalContributions /
                                            model.goal,
                                        animation: true,
                                        animationDuration: 2500,
                                        barRadius: Radius.circular(10),
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        backgroundColor:
                                            Color.fromARGB(167, 216, 216, 216),
                                        progressColor:
                                            Color.fromARGB(255, 32, 146, 80),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Great start! ",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "${model.totalContributions}",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                " out of ",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "${model.goal}",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              Text(
                                " done! ",
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: Provider.of<ContributionModel>(context, listen: false)
                    .getAQR(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('Something Error Occured'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data found'));
                  } else {
                    var documents = snapshot.data!.docs;
                    var data = documents[0].data() as Map<String, dynamic>;

                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 252, 243, 216),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded =
                                      !_isExpanded; // Toggle the expanded state
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pyment Info",
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                      fontSize: AppSizes.fontSmall,
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _downloadQRCode(context);
                                          },
                                          child: Icon(
                                            Icons.download,
                                            size: 22,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Icon(
                                          _isExpanded
                                              ? Icons.arrow_drop_up_outlined
                                              : Icons.arrow_drop_down,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (_isExpanded) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                        child: Image.memory(
                                            base64Decode(data["qr_image"]))),
                                    SizedBox(
                                        height:
                                            10), // Space between image and UPID

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: data["upiId"]));
                                          final snackBar = SnackBar(
                                              content: const Text(
                                                  "Copied UPI ID to clipboard"));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .07,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "UPI ID: ${data["upiId"]}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Icon(
                                                Icons.copy,
                                                size: 22,
                                                color: Colors.blueGrey,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.colorText, // Set the border color here
                      width: 1.0, // Set the border width
                    ),
                    backgroundColor: AppColors.textFieldColor3,
                    shape: const StadiumBorder(),
                    fixedSize: Size(
                      responsiveSizes.dynamicWidth(40),
                      responsiveSizes.dynamicHeight(2),
                    ),
                  ),
                  onPressed: () async {
                    const phoneNumber =
                        '9961624063'; // Replace with support number
                    await launch(
                        "https://wa.me/+91 ${9961624063}?text=Hello, I need support with the app.");
                    // if (await canLaunch) {
                    //   await launch(
                    //       "https://wa.me/+91 ${9961624063}?text=Hello, I need support with the app.");
                    // } else {
                    //   // Handle if WhatsApp is not installed or URL cannot be launched
                    //   print("Could not launch WhatsApp");
                    // }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(FontAwesomeIcons.whatsapp),
                      Text(
                        'Support',
                        style: TextStyle(
                          color: AppColors.buttonColor1,
                          fontSize: responsiveSizes.dynamicFont(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top List",
                      style: TextStyle(
                        fontFamily: "Poppins-Medium",
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        fontSize: 17,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Viewalltransaction()));
                      },
                      child: Container(
                        height: 30,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 61, 65, 101),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "View All",
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontSize: AppSizes.fontSmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              StreamBuilder<QuerySnapshot>(
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
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((doc) {
                      return RefactoredContainer(doc: doc);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
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

  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  Future<void> _downloadQRCode(BuildContext context) async {
    print("====================");
    setState(() {
      _isDownloading = true;
    });

    if (_isDownloading) print(_isDownloading);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text("Downloading...."),
            ],
          ),
        ),
      ),
    );

    try {
      // Get the app's document directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath =
          '${appDocDir.path}/qr_code.png'; // File path to save the asset image

      // Read the asset file
      final byteData = await rootBundle
          .load('assets/qr_code.png'); // Adjust the path as necessary
      final buffer = byteData.buffer.asUint8List();

      // Write the asset file to the document directory
      final file = File(filePath);
      await file.writeAsBytes(buffer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR Code downloaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download QR Code')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }
}
