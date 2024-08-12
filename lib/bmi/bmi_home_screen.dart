import 'dart:math';
import 'package:darth_runner/widgets/button.dart';
import 'age_weight_widget.dart';
import 'gender_widget.dart';
import 'height_widget.dart';
import 'score_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BMIHomeScreen extends StatefulWidget {
  const BMIHomeScreen({super.key});

  @override
  State<BMIHomeScreen> createState() => _BMIHomeScreenState();
}

class _BMIHomeScreenState extends State<BMIHomeScreen> {
  int _gender = 0;
  int _height = 160;
  int _age = 25;
  int _weight = 60;
  double _bmiScore = 0;

  // FUNCTION TO CALCULATE BMI

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }

  // VALIDATE AGE, WEIGHT AND HEIGHT INPUT AND PRODUCE ERROR MESSAGE IF THE INPUT IS INVALID

  bool _validateInputs() {
    String message = '';
    if (_age < 1 || _age > 100) {
      message += 'Age must be between 1 and 100.\n';
    }
    if (_weight < 1 || _weight > 300) {
      message += 'Weight must be between 1 and 300 kg.\n';
    }
    if (_height < 1 || _height > 260) {
      message += 'Height must be between 1 and 260 cm.\n';
    }

    if (message.isNotEmpty) {
      _showErrorDialog(message);
      return false;
    }
    return true;
  }

  // ERROR DIALOG TO LET USER KNOW THEY HAVE KEYED IN INVALID INPUT

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "BMI Calculator",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),

                // GENDER
                GenderWidget(
                  onChange: (genderVal) {
                    _gender = genderVal;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                // HEIGHT
                HeightWidget(
                  onChange: (heightVal) {
                    _height = heightVal;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                // AGE AND WEIGHT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AgeWeightWidget(
                        onChange: (ageVal) {
                          _age = ageVal;
                        },
                        title: "Age",
                        initValue: 25,
                        min: 1,
                        max: 100),
                    AgeWeightWidget(
                        onChange: (weightVal) {
                          _weight = weightVal;
                        },
                        title: "Weight(Kg)",
                        initValue: 60,
                        min: 1,
                        max: 300)
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                
                // CALCULATE BUTTON
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: CustomButton(
                    label: "Calculate",
                    onPressed: () async {
                      if (_validateInputs()) {
                        calculateBmi();
                        await Navigator.push(
                          context,
                          PageTransition(
                            child: ScoreScreen(
                              bmiScore: _bmiScore,
                              age: _age,
                            ),
                            type: PageTransitionType.fade,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
