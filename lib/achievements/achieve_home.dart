import 'package:darth_runner/widgets/achieve_card.dart';
import 'package:flutter/material.dart';

class AchieveHome extends StatelessWidget {
  const AchieveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          'Achievements',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: false,
        titleSpacing: 25,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              AchieveCard(
                  title: "tityyyyyyyyyygvfvcftcytfcytfyyttttttttttle",
                  image: "assets/img/gradient.png",
                  description:
                      "descrekrhgebkfrjhutcbutrcutrcutrbctcytrfcbkweuhbrkcjweh rkuehwkhure chwe kuiption"),
              AchieveCard(
                  title: "title",
                  image: "assets/img/gradient.png",
                  description: "description"),
            ],
          ),
        ),
      ),
    );
  }
}
