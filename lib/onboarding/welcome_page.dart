import 'package:darth_runner/pages/navigation.dart';
import 'package:flutter/material.dart';

// THis is the intro page with a first time per new account,
// tutorial screen
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 7, 1, 28),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: [

                // LOGO
                Padding(
                  padding: const EdgeInsets.only(left: 50, top: 200, right: 50),
                  child: Image.asset(
                    'assets/img/darthrunner_logo.jpeg',
                  ),
                ),
                const SizedBox(height: 40),

                // WELCOME TEXT
                const Text(
                  'Welcome to Darth Runner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(202, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 27),
                ),
                const SizedBox(
                  height: 10,
                ),

                // START BUTTON
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotHomePage()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 38, 15, 77),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                            child: Text(
                          'Begin My Journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ))),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
