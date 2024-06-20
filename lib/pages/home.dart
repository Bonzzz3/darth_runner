import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/bmi/home_screen.dart';
import 'package:darth_runner/social/community_home.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          'Welcome Home',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: false,
        titleSpacing: 25,
        automaticallyImplyLeading: false,
        actions: const [
          // IconButton(
          //   icon: Image.asset('lib/assets/images/darthrunner_logo.jpeg'),
          //   color: Colors.white,
          //   onPressed: () {
          //     // do something
          //   },
          // ),
          CircleAvatar(
            minRadius: 25,
            maxRadius: 25,
            foregroundImage:
                AssetImage('lib/assets/images/darthrunner_logo.jpeg'),
          ),
          SizedBox(
            width: 25,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),

              CustomButton(
                label: "Communities",
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CommunityHome()));
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
            ],
          ),
        ),
      ),
    );
  }
}
