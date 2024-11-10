import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'models/contribution_model.dart';
import 'screens/contribution_screen.dart';
import 'screens/imageUploadScreen.dart';
import 'screens/maintananceScreen.dart';
import 'screens/paymentDone.dart';
import 'servise/notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(); // Initialize Firebase
  // await initializeNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ContributionModel(),
      child: MyApp(),
    ),
  );
  // runApp(
  //   ChangeNotifierProvider(
  //     create: (context) => ContributionModel(),
  //     child: MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ഈത്തപ്പഴ ചലഞ്ച്',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
      ),
      home: StreamBuilder<bool>(
        stream: Provider.of<ContributionModel>(context, listen: false)
            .checkMaintenanceStatusStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while waiting
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            ); // Handle error state
          } else if (snapshot.hasData && snapshot.data != null) {
            bool isMaintenance = snapshot.data ?? false;
            return isMaintenance
                ? MaintenanceScreen()
                :
                //  ImageUploadScreen();

                ContributionScreen();
          } else {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            ); // Default error screen if no data
          }
        },
      ),
    );
  }
}
