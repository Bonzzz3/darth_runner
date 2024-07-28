import 'dart:io';
import 'package:darth_runner/database/rundata.dart';
import 'package:darth_runner/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'themes/themes_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp();
  }

  await Hive.initFlutter();
  Hive.registerAdapter(RundataAdapter());
  var box = await Hive.openBox<Rundata>('runDataBox');
  for (var key in box.keys) {
    var runData = box.get(key) as Rundata?;
    if (runData != null && runData.snapshotUrl == null) {
      runData.snapshotUrl = '';
      await box.put(key, runData);
    }
  }
  

  runApp(
    Phoenix(
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(false),
        child: const MyApp(),
      )
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier,child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.currentTheme,
          home: const Wrapper(),
        );
      }
    );
  }
}
