import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:date_palm_challenge/screens/signUpScreen.dart';
import 'package:date_palm_challenge/servise/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screenshot/screenshot.dart';
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
import 'package:http/http.dart' as http;

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

  String bnrUrl = "";
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      phoneNumber = prefs.getString('phoneNumber');
      // _phoneController.text = phoneNumber.toString();
    });

    List<Map<String, dynamic>> sliderList = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('banner').get();

      // Clear the sliderList to avoid appending on every call
      sliderList.clear();

      for (var doc in querySnapshot.docs) {
        // Assuming each document has an 'id' and 'ban2' field.
        Map<String, dynamic> a = {
          "id": doc.id,
          "ban2": doc["ban2"] ?? "", // Ensure ban2 is not null
        };
        sliderList.add(a);
      }

      // Update the `bnrUrl` with the first banner (if available)
      if (sliderList.isNotEmpty) {
        setState(() {
          bnrUrl = sliderList[0]["ban2"];
        });
      } else {
        // Handle case when no banners are found
        setState(() {
          bnrUrl = ""; // or a default URL or fallback
        });
      }
    } catch (e) {
      print("Error fetching banner data: $e");
      setState(() {
        bnrUrl = ""; // Set a fallback URL if there's an error
      });
    }
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
        title: username != null
            ? Text(
                "Hi , ${username}",
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  fontSize: 17,
                ),
              )
            : null,
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            // LoginScreen()
                            SignUpScreen()));
              }
            },
            child: username != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundColor: Color.fromARGB(255, 241, 230, 230),
                    backgroundImage: AssetImage("assets/face1.png"),
                  )
                : Text(
                    "Sign Up",
                    style: TextStyle(fontSize: AppSizes.fontMedium),
                  ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // child: bnrUrl != ""
                  //     ? Image.network(
                  //         bnrUrl,
                  //         fit: BoxFit.fill,
                  //         loadingBuilder: (BuildContext context, Widget child,
                  //             ImageChunkEvent? loadingProgress) {
                  //           if (loadingProgress == null) {
                  //             return child; // Image has loaded
                  //           } else {
                  //             return Center(
                  //               child: CircularProgressIndicator(
                  //                 value: loadingProgress.expectedTotalBytes !=
                  //                         null
                  //                     ? loadingProgress.cumulativeBytesLoaded /
                  //                         (loadingProgress.expectedTotalBytes ??
                  //                             1)
                  //                     : null,
                  //               ), // Show a loading indicator while the image is loading
                  //             );
                  //           }
                  //         },
                  //         errorBuilder: (context, error, stackTrace) {
                  //           return Center(
                  //               child: Icon(Icons
                  //                   .error)); // Show error icon if image fails to load
                  //         },
                  //       )
                  //     : Image.asset(
                  //         "assets/banner2.png",
                  //         fit: BoxFit.fill,
                  //       ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('banner')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // Image has loaded
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ), // Show loading indicator while the image is loading
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                                child: Icon(Icons
                                    .error)); // Show error icon if image fails to load
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
                                        if (_isExpanded)
                                          InkWell(
                                            onTap: () {
                                              if (!Platform.isIOS) {
                                                _downloadQRCode(
                                                    context, data["qr_image"]);
                                              } else {
                                                print("-");
                                                _takeAndSaveScreenshot();
                                              }
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
                                    if (data["qr_image"] != "")
                                      GestureDetector(
                                        onTap: () {
                                          _downloadQRCode(
                                              context, data["qr_image"]);
                                        },
                                        child: Container(
                                          height: 250,
                                          child: Screenshot(
                                            controller: screenshotController,
                                            child: Builder(
                                              builder: (context) {
                                                try {
                                                  return Image(
                                                    image: NetworkImage(
                                                        data["qr_image"]),
                                                  );
                                                } catch (e) {
                                                  print(
                                                      "Error decoding image: $e");
                                                  return Center(
                                                    child: Text(
                                                      "Invalid QR Code Image",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                        height:
                                            10), // Space between image and UPID

                                    if (data["upiId"] != "")
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
                                    if (data["ac_no"] != "")
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: data["ac_no"]));
                                                  final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Copied Account number to clipboard"));

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "A/C NO : ${data["ac_no"]}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: data["ifsc"]));
                                                  final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Copied IFSC to clipboard"));

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "IFSC : ${data["ifsc"]}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                            ],
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
                      "Today Top List",
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
                    .where('createdAt',
                        isGreaterThanOrEqualTo: DateTime.now().subtract(
                            Duration(
                                hours: DateTime.now().hour,
                                minutes: DateTime.now().minute,
                                seconds: DateTime.now().second,
                                milliseconds: DateTime.now().millisecond,
                                microseconds: DateTime.now().microsecond)))
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No today contributions yet.'));
                  }
                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
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
              child: Text('Sign Up'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            //  LoginScreen()
                            SignUpScreen()));
              },
            ),
            TextButton(
              child: Text('Cancel'),
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

  // Future<void> _downloadQRCode(BuildContext context) async {
  //   print("====================");
  //   setState(() {
  //     _isDownloading = true;
  //   });

  //   if (_isDownloading) print(_isDownloading);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Padding(
  //         padding: const EdgeInsets.only(top: 8.0),
  //         child: Row(
  //           children: [
  //             Text("Downloading...."),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  //   try {
  //     // Get the app's document directory
  //     final appDocDir = await getApplicationDocumentsDirectory();
  //     final filePath =
  //         '${appDocDir.path}/qr_code.png'; // File path to save the asset image

  //     // Read the asset file
  //     final byteData = await rootBundle
  //         .load('assets/qr_code.png'); // Adjust the path as necessary
  //     final buffer = byteData.buffer.asUint8List();

  //     // Write the asset file to the document directory
  //     final file = File(filePath);
  //     await file.writeAsBytes(buffer);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('QR Code downloaded successfully')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to download QR Code')),
  //     );
  //   } finally {
  //     setState(() {
  //       _isDownloading = false;
  //     });
  //   }
  // }
  Future<void> _downloadQRCode(BuildContext context, String base64Image) async {
    setState(() {
      _isDownloading = true;
    });

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

    // try {
    //   // Decode the base64 image
    //   final decodedBytes = base64Decode(base64Image);

    //   // Get the app's document directory
    //   final appDocDir = await getApplicationDocumentsDirectory();
    //   final filePath = '${appDocDir.path}/qr_code.png';

    //   // Write the decoded image bytes to a file
    //   final file = File(filePath);
    //   await file.writeAsBytes(decodedBytes);

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('QR Code downloaded successfully at $filePath')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to download QR Code: $e')),
    //   );
    // } finally {
    //   setState(() {
    //     _isDownloading = false;
    //   });
    // }
    try {
      // // Request storage permission
      // if (await _requestStoragePermission()) {
      //   // Request notification permission
      //   // await _requestNotificationPermission();

      //   // Decode the base64 image
      //   final decodedBytes = base64Decode(base64Image);

      //   // Get the Downloads directory
      //   final directory = Directory('/storage/emulated/0/Download');
      //   String fileName =
      //       'receipt_image_${DateTime.now().millisecondsSinceEpoch}.png';
      //   final filePath = '${directory.path}/$fileName';

      //   // Write the image bytes to the file
      //   final file = File(filePath);
      //   await file.writeAsBytes(decodedBytes);

      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //         content: Text('QR Code downloaded successfully at $filePath')),
      //   );

      //   // Show download notification
      //   await _showDownloadNotification();
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Storage permission denied')),
      //   );
      // }

      if (await _requestStoragePermission()) {
        // Decode the base64 image

        final response = await http.get(Uri.parse(base64Image));
        if (response.statusCode == 200) {
          final decodedBytes = response.bodyBytes;
          if (Platform.isAndroid) {
            // Android: Save to Downloads directory
            final directory = Directory('/storage/emulated/0/Download');
            String fileName =
                'receipt_image_${DateTime.now().millisecondsSinceEpoch}.png';
            final filePath = '${directory.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(decodedBytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('QR Code downloaded successfully at $filePath')),
            );
          } else if (Platform.isIOS) {
            // iOS: Save to app's Documents directory or Photos library
            final directory = await getApplicationDocumentsDirectory();
            String fileName =
                'receipt_image_${DateTime.now().millisecondsSinceEpoch}.png';
            final filePath = '${directory.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(decodedBytes);

            // Optionally save to Photos library
            final result = await ImageGallerySaver.saveFile(filePath);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['isSuccess']
                    ? 'QR Code saved to Photos successfully'
                    : 'Failed to save QR Code'),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download QR Code: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  // Future<bool> _requestStoragePermission() async {
  //   // Handle permission request for Android 13+ (API level 33)
  //   if (Platform.isAndroid && (await Permission.storage.isDenied)) {
  //     var status = await Permission.storage.request();
  //     if (status.isGranted) return true;

  //     // For Android 13+ use READ_MEDIA_IMAGES permission
  //     if (await Permission.mediaLibrary.request().isGranted) return true;
  //   }
  //   return false;
  // }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Handle storage permission for Android
      if (await Permission.storage.isDenied) {
        var status = await Permission.storage.request();
        if (status.isGranted) return true;

        // For Android 13+ use READ_MEDIA_IMAGES permission
        if (await Permission.mediaLibrary.request().isGranted) return true;
      }
    } else if (Platform.isIOS) {
      // Handle media library permission for iOS
      if (await Permission.photos.isDenied) {
        var status = await Permission.photos.request();
        if (status.isGranted) return true;
      }
    }
    return false;
  }

  // Future<void> _showDownloadNotification() async {
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'download_channel', // Channel ID
  //     'Downloads', // Channel name
  //     channelDescription: 'Notification for downloaded files',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );

  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'Download Complete',
  //     'QR Code saved successfully to Downloads folder',
  //     notificationDetails,
  //   );
  // }

  Future<void> _showDownloadNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'download_channel', // Channel ID
      'Downloads', // Channel name
      channelDescription: 'Notification for downloaded files',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/launcher_icon',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'QR Code saved successfully to Downloads folder',
      notificationDetails,
    );
  }

  final ScreenshotController screenshotController = ScreenshotController();
  Future<void> _takeAndSaveScreenshot() async {
    try {
      // setState(() {
      //   _isDownloading = true;
      // });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Padding(
      //       padding: const EdgeInsets.only(top: 8.0),
      //       child: Row(
      //         children: [
      //           Text("Downloading...."),
      //         ],
      //       ),
      //     ),
      //   ),
      // );
      // Capture the screenshot
      // print(screenshotController.capture());
      screenshotController.capture().then((Uint8List? imageScre) async {
        print(imageScre);
        if (imageScre != null) {
          // Request permission to access the photo gallery
          final permission = await PhotoManager.requestPermissionExtend();
          if (permission.isAuth) {
            // Get the photo album
            final album =
                await PhotoManager.editor.saveImage(imageScre, filename: 'Qr');
            print(album);
            if (album != null) {
              print('Screenshot saved to gallery');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('QR Code downloaded successfully')),
              );
            }
          } else {
            print('Permission denied to access photo gallery');
          }
        }
      }).catchError((e) {
        print('Error capturing screenshot: $e');
      });
    } catch (e) {
      print('Error: $e');
    }

    // try {
    //   print("----");
    //   final image = await screenshotController.capture();
    //   if (image != null) {
    //     print("Screenshot captured successfully");
    //     showDialog(
    //       context: context,
    //       builder: (context) => Dialog(
    //         child: Image.memory(image),
    //       ),
    //     );
    //   } else {
    //     print("Failed to capture screenshot");
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }
}
