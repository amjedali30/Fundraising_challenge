import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'models/contribution_model.dart';
import 'screens/contribution_screen.dart';
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

  // Initialize iOS settings
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Combine Android and iOS settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // const InitializationSettings initializationSettings =
  //     InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(); // Initialize Firebase
  // await initializeNotifications();

  await _requestPermissions();

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

Future<void> _requestPermissions() async {
  // Request storage permission for both Android and iOS
  if (await Permission.storage.request().isGranted) {
    print('Storage permission granted');
  } else {
    print('Storage permission denied');
  }
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
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 150,
                    left: 110,
                    child: Image.asset(
                      "assets/appLogo.jpg",
                      width: 200,
                    ),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            ); //// Loading indicator while waiting
          } else if (snapshot.hasError) {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 150,
                    left: 110,
                    child: Image.asset(
                      "assets/appLogo.jpg",
                      width: 200,
                    ),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            ); //
          } else if (snapshot.hasData && snapshot.data != null) {
            bool isMaintenance = snapshot.data ?? false;
            return isMaintenance
                ? MaintenanceScreen()
                : AnimatedSplashScreen(
                    splash: Image.asset('assets/appLogo.jpg'),
                    splashIconSize: 150,
                    nextScreen: ContributionScreen(),
                    splashTransition: SplashTransition.scaleTransition,
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    duration: 2500,
                  );
          } else {
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 150,
                    left: 110,
                    child: Image.asset(
                      "assets/appLogo.jpg",
                      width: 200,
                    ),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            ); //
          }
        },
      ),
    );
  }
}
