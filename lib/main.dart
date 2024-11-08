import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/contribution_model.dart';
import 'screens/contribution_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContributionModel(),
      child: MyApp(),
    ),
  );
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
        home: ContributionScreen()

        // ReceiptScreen(
        //     username: "Amjad",
        //     userPhotoUrl:
        //         "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
        //     contributionCount: 2),
        );
  }
}
