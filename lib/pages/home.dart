import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/bmi/home_screen.dart';
import 'package:darth_runner/social/home_social.dart';
import 'package:darth_runner/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // begin: Alignment(-1,-1),
              // end: Alignment(0.7,1),
              colors: [
                Color.fromARGB(255, 6, 4, 120),
                Color.fromARGB(255, 174, 12, 0)
              ],
            ),
          ),
        ),
        const Positioned(
          top: 52,
          right: 20,
          child: CircleAvatar(
            minRadius: 25,
            maxRadius: 25,
            foregroundImage:
                AssetImage('lib/assets/images/darthrunner_logo.jpeg'),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                // elevation: 0,
                title: const Text(
                  'Welcome Home',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 50),

              CustomButton(
                label: "Social",
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeSocial()));
                },
              ),
              const SizedBox(height: 20),

              // BMI button
              CustomButton(
                label: "BMI",
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: "Sign Out",
                onPressed: () async {
                  await auth.signout();
                  Phoenix.rebirth(context);
                },
              )
            ],
          ),
        ),
      ],
    ));
  }
}
