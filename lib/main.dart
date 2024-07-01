import 'package:darth_runner/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';

// import 'package:darth_runner/pages/intro_page.dart';
// import 'package:flutter/services.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //CREATING BOX
  var box = await Hive.openBox('myRuns');
  
  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: (ThemeData(primarySwatch: Colors.blue)),
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
    );
  }
}
