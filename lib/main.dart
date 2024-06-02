
import 'package:darth_runner/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:darth_runner/pages/intro_page.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';


Future<void> main() async {
 // enable the app to be in full screen, hiding the notification bar
// uncomment the below and package import
// problems when loading screen, need to add padding around appbar 
// the bottom nav bar end up hiding

  // WidgetsFlutterBinding.ensureInitialized();
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: (
        ThemeData(
          primarySwatch: Colors.blue
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      //wrapper direct to homepage which is IntroPage()
    );
  }
}