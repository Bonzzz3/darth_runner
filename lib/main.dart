import 'package:darth_runner/pages/intro_page.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main() {
// enable the app to be in full screen, hiding the notification bar
// uncomment the below and package import
// problems when loading screen, need to add padding around appbar 
// the bottom nav bar end up hiding

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

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
      home: const IntroPage()
    );
  }
}