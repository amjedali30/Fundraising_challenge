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



// import 'dart:io';

// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'models/contribution_model.dart';
// import 'screens/contribution_screen.dart';
// import 'screens/maintananceScreen.dart';
// import 'screens/paymentDone.dart';
// import 'servise/notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase

//   // Initialize notifications
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const DarwinInitializationSettings initializationSettingsIOS =
//       DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ContributionModel(),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Request permissions after the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _requestPermissions();
//     });

//     return MaterialApp(
//       navigatorKey: navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'ഈത്തപ്പഴ ചലഞ്ച്',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: "Poppins",
//       ),
//       home: StreamBuilder<bool>(
//         stream: Provider.of<ContributionModel>(context, listen: false)
//             .checkMaintenanceStatusStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//               color: Colors.white,
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 150,
//                     left: 110,
//                     child: Image.asset(
//                       "assets/appLogo.jpg",
//                       width: 200,
//                     ),
//                   ),
//                   Center(child: CircularProgressIndicator()),
//                 ],
//               ),
//             ); // Loading indicator
//           } else if (snapshot.hasError) {
//             return Container(
//               color: Colors.white,
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 150,
//                     left: 110,
//                     child: Image.asset(
//                       "assets/appLogo.jpg",
//                       width: 200,
//                     ),
//                   ),
//                   Center(child: CircularProgressIndicator()),
//                 ],
//               ),
//             ); // Error indicator
//           } else if (snapshot.hasData && snapshot.data != null) {
//             bool isMaintenance = snapshot.data ?? false;
//             return isMaintenance
//                 ? MaintenanceScreen()
//                 : AnimatedSplashScreen(
//                     splash: Image.asset('assets/appLogo.jpg'),
//                     splashIconSize: 150,
//                     nextScreen: ContributionScreen(),
//                     splashTransition: SplashTransition.scaleTransition,
//                     backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                     duration: 2500,
//                   );
//           } else {
//             return Container(
//               color: Colors.white,
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 150,
//                     left: 110,
//                     child: Image.asset(
//                       "assets/appLogo.jpg",
//                       width: 200,
//                     ),
//                   ),
//                   Center(child: CircularProgressIndicator()),
//                 ],
//               ),
//             ); // Default loading indicator
//           }
//         },
//       ),
//     );
//   }
// }

// Future<void> _requestPermissions() async {
//   if (Platform.isAndroid) {
//     // Check the current status of the permission
//     var status = await Permission.storage.status;

//     if (status.isGranted) {
//       print('Storage permission already granted');
//     } else if (status.isPermanentlyDenied) {
//       print('Storage permission permanently denied');
//       // Show a dialog to guide the user to settings
//       _showSettingsDialog();
//     } else {
//       // Request the permission
//       status = await Permission.storage.request();
//       if (status.isGranted) {
//         print('Storage permission granted');
//       } else {
//         print('Storage permission denied');
//       }
//     }
//   } else if (Platform.isIOS) {
//     // Check Photos permission for iOS
//     var status = await Permission.photos.status;
//     print(status);
//     if (status.isGranted) {
//       print('Photos permission already granted');
//     } else if (status.isDenied) {
//       print('Photos permission permanently denied');
//       // Show a dialog to guide the user to settings
//       _showSettingsDialog();
//     } else {
//       // Request the permission
//       status = await Permission.photos.request();
//       if (status.isGranted) {
//         print('Photos permission granted');
//       } else {
//         print('Photos permission denied');
//       }
//     }
//   }
// }

// void _showSettingsDialog() {
//   showDialog(
//     context: navigatorKey.currentContext!,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Permission Required'),
//         content: Text(
//           'Storage permission is required to proceed. Please enable it in the app settings.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               openAppSettings(); // Opens the app settings page
//             },
//             child: Text('Open Settings'),
//           ),
//         ],
//       );
//     },
//   );
// }