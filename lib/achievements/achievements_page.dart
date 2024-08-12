import 'package:darth_runner/database/rundata.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AchieveCard extends StatelessWidget {
  final String title;
  final String image;
  final String description;
  final bool isCompleted;

  const AchieveCard({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        //border: Border.all(color: Colors.black, width: 2),
      ),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image
          CircleAvatar(
            minRadius: 30,
            maxRadius: 30,
            backgroundColor: Colors.purple[100],
            child: SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(image),
            ),
          ),
          const SizedBox(width: 5),
          // title and description
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // status
          Text(
            isCompleted ? "Completed" : "Incomplete",
            style: TextStyle(
              color: isCompleted ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementsHomePage extends StatefulWidget {
  const AchievementsHomePage({super.key});

  @override
  State<AchievementsHomePage> createState() => _AchievementsHomePageState();
}

class _AchievementsHomePageState extends State<AchievementsHomePage> {
  late Box<Rundata> runDataBox;
  List<Map<String, dynamic>> achievements = [
    {
      'title': 'First Steps',
      'image': "assets/badges/track.png",
      'description': 'Complete your first run.',
      'isCompleted': false,
    },
    {
      'title': 'Warm-up Lap',
      'image': "assets/badges/workout.png",
      'description': 'Run 1 kilometer.',
      'isCompleted': false,
    },
    {
      'title': '5K Champ',
      'image': 'assets/badges/speed.png',
      'description': 'RUn 5 kilometers.',
      'isCompleted': false,
    },
    {
      'title': '10K Finisher',
      'image': 'assets/badges/finish-line.png',
      'description': 'Run 10 kilometers.',
      'isCompleted': false,
    },
    {
      'title': 'Quick Starter',
      'image': 'assets/badges/footstep.png',
      'description': 'Run for 10 minutes.',
      'isCompleted': false,
    },
    {
      'title': 'Half-Hour Hustle',
      'image': 'assets/badges/walking.png',
      'description': 'Run for 30 minutes.',
      'isCompleted': false,
    },
    {
      'title': 'Endurance Expert',
      'image': 'assets/badges/running.png',
      'description': 'Run for 1 hour.',
      'isCompleted': false,
    },
    {
      'title': 'Consistency is Key',
      'image': 'assets/badges/key.png',
      'description': 'Run 3 times in one week.',
      'isCompleted': false,
    },
    {
      'title': 'Speedy Demon',
      'image': 'assets/badges/helmet.png',
      'description': 'Complete a kilometer in under 5 minutes.',
      'isCompleted': false,
    },
    {
      'title': 'Weekly Warrior',
      'image': 'assets/img/spartan.png',
      'description': 'Run 7 times in one week.',
      'isCompleted': false,
    },
    {
      'title': '10 Runs Completed',
      'image': 'assets/badges/10.png',
      'description': 'Complete 10 runs.',
      'isCompleted': false,
    },
    {
      'title': '50 Runs Completed',
      'image': 'assets/badges/50.png',
      'description': 'Complete 50 runs.',
      'isCompleted': false,
    },
    {
      'title': '100 Runs Completed',
      'image': 'assets/badges/100.png',
      'description': 'Complete 100 runs.',
      'isCompleted': false,
    },
    {
      'title': 'Morning bird',
      'image': 'assets/badges/toucan.png',
      'description': 'Run between 3AM and 6AM',
      'isCompleted': false,
    },
    {
      'title': 'Night Owl',
      'image': 'assets/badges/owl.png',
      'description': 'Run between 12AM and 3AM',
      'isCompleted': false,
    },
    {
      'title': 'Half Marathon',
      'image': 'assets/badges/marathon.png',
      'description': 'Run 26.1 kilometers.',
      'isCompleted': false,
    },
    {
      'title': 'Marathon',
      'image': 'assets/badges/marathon.png',
      'description': 'Run 42.2 kilometers.',
      'isCompleted': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    runDataBox = Hive.box<Rundata>('runDataBox');
    _checkAchievements();
  }

  int durationToMinutes(String duration) {
    List<String> parts = duration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return hours * 60 + minutes + (seconds / 60).round();
  }

  void _checkAchievements() {
    setState(() {
      achievements[0]['isCompleted'] = userHasCompletedFirstRun();
      achievements[1]['isCompleted'] = userHasCompleted1KRUn();
      achievements[2]['isCompleted'] = userHasCompleted5KRun();
      achievements[3]['isCompleted'] = userHasCompleted10KRun();
      achievements[4]['isCompleted'] = userHasCompleted10MinRun();
      achievements[5]['isCompleted'] = userHasCompleted30MinRun();
      achievements[6]['isCompleted'] = userHasCompleted60MinRun();
      achievements[7]['isCompleted'] = userHasCompleted3xWeek();
      achievements[8]['isCompleted'] = userHasCompleted1KIn5Min();
      achievements[9]['isCompleted'] = userHasCompleted7days();
      achievements[10]['isCompleted'] = userHasCompleted10Runs();
      achievements[11]['isCompleted'] = userHasCompleted50Runs();
      achievements[12]['isCompleted'] = userHasCompleted100Runs();
      achievements[13]['isCompleted'] = userHasCompletedMorningBird();
      achievements[14]['isCompleted'] = userHasCompletedNightOwl();
      achievements[15]['isCompleted'] = userHasCompletedHalfMarathon();
      achievements[16]['isCompleted'] = userHasCompletedMarathon();
    });
  }

  bool userHasCompletedFirstRun() {
    return runDataBox.isNotEmpty; // CHECKS IF RUN DATA HAS ATLEAST 1 RUN
  }

  bool userHasCompleted1KRUn() {
    return runDataBox.values.any(
        (run) => run.hiveDistance >= 1.0); // CHECK IF ANY RUN HAS 1K DISTANCE
  }

  bool userHasCompleted5KRun() {
    return runDataBox.values.any(
        (run) => run.hiveDistance >= 5.0); // CHECK IF ANY RUN HAS 5K DISTANCE
  }

  bool userHasCompleted10KRun() {
    return runDataBox.values.any(
        (run) => run.hiveDistance >= 10.0); // CHECK IF ANY RUN HAS 10K DISTANCE
  }

  bool userHasCompleted10MinRun() {
    return runDataBox.values.any((run) =>
        durationToMinutes(run.hiveTime) >= 10); // CHECK IF ANY RUN IS 10 MIN
  }

  bool userHasCompleted30MinRun() {
    return runDataBox.values.any((run) =>
        durationToMinutes(run.hiveTime) >= 30); // CHECK IF ANY RUN IS 30 MIN
  }

  bool userHasCompleted60MinRun() {
    return runDataBox.values.any((run) =>
        durationToMinutes(run.hiveTime) >= 60); // CHECK IF ANY RUN IS 60 MIN
  }

  bool userHasCompleted3xWeek() {
    return false;
  }

  bool userHasCompleted1KIn5Min() {
    return false;
  }

  bool userHasCompleted7days() {
    return false;
  }

  bool userHasCompleted10Runs() {
    return runDataBox.length >= 10; // CHECK IF NO.OF RUNS IS 10
  }

  bool userHasCompleted50Runs() {
    return runDataBox.length >= 50; // CHECK IF NO.OF RUNS IS 50
  }

  bool userHasCompleted100Runs() {
    return runDataBox.length >= 100; // CHECK IF NO.OF RUNS IS 100
  }

  bool userHasCompletedMorningBird() {
    return false;
  }

  bool userHasCompletedNightOwl() {
    return false;
  }

  bool userHasCompletedHalfMarathon() {
    return runDataBox.values.any((run) =>
        run.hiveDistance >= 26.1); // CHECK IF ANY RUN HAS 26.1K DISTANCE
  }

  bool userHasCompletedMarathon() {
    return runDataBox.values.any((run) =>
        run.hiveDistance >= 42.2); // CHECK IF ANY RUN HAS 42.2K DISTANCE
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Achievements",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        child: ListView.builder(
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return AchieveCard(
              title: achievement['title'],
              image: achievement['image'],
              description: achievement['description'],
              isCompleted: achievement['isCompleted'],
            );
          },
        ),
      ),
    );
  }
}
