import 'package:darth_runner/bmi/bmi_home_screen.dart';
import 'package:darth_runner/recommendation/recom_home.dart';
import 'package:darth_runner/social/community_home.dart';
import 'package:darth_runner/themes/themes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
            foregroundImage: AssetImage('assets/img/darthrunner_logo.jpeg'),
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
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // BMI BUTTON
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BMIHomeScreen()));
                  },
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      image: DecorationImage(
                          image: AssetImage("assets/img/redstairs.jpg"),
                          fit: BoxFit.cover),
                    ),
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.all(25),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BMI Calculator",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CustomButton(
                //   label: "Communities",
                //   onPressed: () async {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const CommunityHome()));
                //   },
                // ),

                // COMMUNITIES BUTTON
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CommunityHome()));
                  },
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      image: DecorationImage(
                          image: AssetImage("assets/img/communities.jpg"),
                          fit: BoxFit.cover),
                    ),
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.all(25),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Communities",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecomHome()));
                  },
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/img/recommend-icon-thumb-like.jpg"),
                          fit: BoxFit.cover),
                    ),
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: const EdgeInsets.all(25),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recommendations",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Heartrate button
                // SizedBox(
                //   width: 350,
                //   height: 200,
                //   child: Container(
                //     width: double.infinity,
                //     height: double.infinity,
                //     padding: const EdgeInsets.all(20),
                //     decoration: const BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(30)),
                //       image: DecorationImage(
                //           image: AssetImage("assets/img/galaxy.jpeg"),
                //           fit: BoxFit.cover),
                //     ),
                //     child: GestureDetector(
                //       onTap: () async {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const HeartrateHome()));
                //       },
                //       child: const Text(
                //         "Heart Rate calculator",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 30,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
