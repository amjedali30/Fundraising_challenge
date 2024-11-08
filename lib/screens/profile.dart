import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constent/app_colors.dart';
import '../widget/profileNameTag.dart';
import '../widget/transactionCard.dart';
import 'transactionDetails.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.username, required this.mobileNo});
  String username;
  String mobileNo;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool checkValue = false;

  Future<bool> _loadProfileData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a network call
    return true; // Simulate data load success
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'latto',
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('! Log out '),
                    // content: Text('Log out of Angadi'),
                    actions: <Widget>[
                      OutlinedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                      OutlinedButton(
                        child: Text('Log Out'),
                        onPressed: () {
                          logout();
                        },
                      )
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 290,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Color.fromARGB(255, 241, 230, 230),
                            backgroundImage: AssetImage("assets/face1.png"),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: .4,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        ProfileNameTag(
                          icon: FontAwesomeIcons.user,
                          label: "Name",
                          name: widget.username,
                        ),
                        Container(
                          height: .4,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        ProfileNameTag(
                          icon: Icons.call,
                          label: "Phone Number",
                          name: widget.mobileNo,
                        ),
                        // Container(
                        //   height: .4,
                        //   width: double.infinity,
                        //   color: Colors.grey,
                        // ),
                      ])),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Transaction",
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('contributions')
                      .where('phoneNumber',
                          isEqualTo: widget.mobileNo) // Filter by mobile number
                      .orderBy('count', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container(
                          height: 150,
                          child: Center(child: Text('No contributions yet.')));
                    }
                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        return InkWell(
                            onTap: () {
                              // Navigate to TransactionDetailScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailScreen(
                                    transaction:
                                        doc.data() as Map<String, dynamic>,
                                    docId: doc.id,
                                  ),
                                ),
                              );
                            },
                            child: RefactoredContainer(doc: doc));
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for (String key in preferences.getKeys()) {
      preferences.remove(key);
    }
    setState(() {});
    Navigator.pop(context);
  }
}