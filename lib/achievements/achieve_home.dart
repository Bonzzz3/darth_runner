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
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        child: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AchieveCard(
                  title: "First Step",
                  image: "assets/badges/track.png",
                  description: "Complete your first run.",
                  isCompleted: true,
                ),
                AchieveCard(
                  title: "Warm-up Lap",
                  image: "assets/badges/workout.png",
                  description: "Run 1 kilometer.",
                  isCompleted: true,
                ),
                AchieveCard(
                    title: "5K Champ",
                    image: "assets/badges/speed.png",
                    description: "Run 5 kilometers."),
                AchieveCard(
                    title: "10K Finisher",
                    image: "assets/badges/finish-line.png",
                    description: "Run 10 kilometers."),
                AchieveCard(
                    title: "Marathon Master",
                    image: "assets/badges/marathon.png",
                    description: "Run 42.2 kilometers."),
                AchieveCard(
                    title: "Quick Starter",
                    image: "assets/badges/footstep.png",
                    description: "Run for 10 minutes."),
                AchieveCard(
                    title: "Half-Hour Hustle",
                    image: "assets/badges/walking.png",
                    description: "Run for 30 minutes."),
                AchieveCard(
                    title: "Endurance Expert",
                    image: "assets/badges/running.png",
                    description: "Run for 1 hour."),
                AchieveCard(
                    title: "Consistency is Key",
                    image: "assets/badges/key.png",
                    description: "Run 3 times in one week."),
                AchieveCard(
                    title: "Weekly Warrior",
                    image: "assets/img/spartan.png",
                    description: "Run 7 times in one week."),
                AchieveCard(
                    title: "Speedy Demon",
                    image: "assets/badges/helmet.png",
                    description: "Complete a kilometer in under 5 minutes."),
                AchieveCard(
                    title: "10 Runs Completed",
                    image: "assets/badges/10.png",
                    description: "Complete 10 runs."),
                AchieveCard(
                    title: "50 Runs Completed",
                    image: "assets/badges/50.png",
                    description: "Complete 50 runs."),
                AchieveCard(
                    title: "100 Runs Completed",
                    image: "assets/badges/100.png",
                    description: "Complete 100 runs."),
                AchieveCard(
                    title: "Morning bird",
                    image: "assets/badges/toucan.png",
                    description: "Complete a run before 6AM"),
                AchieveCard(
                    title: "Night Owl",
                    image: "assets/badges/owl.png",
                    description: "Complete a run before 6AM"),
                SizedBox(
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
