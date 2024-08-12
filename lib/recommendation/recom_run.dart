import 'package:darth_runner/recommendation/run_beginner.dart';
import 'package:darth_runner/recommendation/run_marathon.dart';
import 'package:darth_runner/recommendation/run_race.dart';
import 'package:darth_runner/widgets/recom_card.dart';
import 'package:flutter/material.dart';

class RecomRun extends StatelessWidget {
  const RecomRun({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RecomCard(
            mainText: "Beginner",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RunBeginner(),
                ),
              );
            },
          ),
          RecomCard(
            mainText: "Marathon",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RunMarathon(),
                ),
              );
            },
          ),
          RecomCard(
            mainText: "Race",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RunRace(),
                ),
              );
            },
          ),
          // RecomCard(
          //   mainText: "Expert",
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const RunExpert(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
