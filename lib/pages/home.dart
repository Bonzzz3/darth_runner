import 'package:darth_runner/bmi/bmi_home_screen.dart';
import 'package:darth_runner/social/community_home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // BMI button
                SizedBox(
                  width: 350,
                  height: 200,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      image: DecorationImage(
                          image: AssetImage("assets/img/redstairs.jpg"),
                          fit: BoxFit.cover),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BMIHomeScreen()));
                      },
                      child: const Text(
                        "BMI Calculator",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

                const SizedBox(height: 20),
                // Communities button
                SizedBox(
                  width: 350,
                  height: 200,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      image: DecorationImage(
                          image: AssetImage("assets/img/communities.jpg"),
                          fit: BoxFit.cover),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CommunityHome()));
                      },
                      child: const Text(
                        "Communities",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
