import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 69, 72),
      body: Column(
        children: [
          //logo
          Image.asset('lib/assets/images/darthrunner_logo.jpeg')
          //title

          // start button
        ],
      )
      );
  }
}