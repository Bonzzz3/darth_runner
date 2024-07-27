import 'package:darth_runner/recommendation/diet_muscle_growth.dart';
import 'package:darth_runner/recommendation/diet_runners.dart';
import 'package:darth_runner/recommendation/diet_weightloss.dart';
import 'package:darth_runner/widgets/recom_card.dart';
import 'package:flutter/material.dart';

class RecomDiet extends StatelessWidget {
  const RecomDiet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecomCard(
          mainText: "Runners",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DietRunners(),
              ),
            );
          },
        ),
        RecomCard(
          mainText: "Weight Loss",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DietWeightloss(),
              ),
            );
          },
        ),
        RecomCard(
          mainText: "Muscle Growth",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DietMuscleGrowth(),
              ),
            );
          },
        ),
      ],
    );
  }
}
