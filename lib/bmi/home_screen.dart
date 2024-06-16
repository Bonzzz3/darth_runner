import 'dart:math';

import 'package:darth_runner/widgets/button.dart';

import 'age_weight_widget.dart';
import 'gender_widget.dart';
import 'height_widget.dart';
import 'score_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _gender = 0;
  int _height = 160;
  int _age = 25;
  int _weight = 60;
  bool _isFinished = false;
  double _bmiScore = 0;

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
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // Gender
              GenderWidget(
                onChange: (genderVal) {
                  _gender = genderVal;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // Height
              HeightWidget(
                onChange: (heightVal) {
                  _height = heightVal;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              // Age and Weight
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AgeWeightWidget(
                      onChange: (ageVal) {
                        _age = ageVal;
                      },
                      title: "Age",
                      initValue: 25,
                      min: 0,
                      max: 100),
                  AgeWeightWidget(
                      onChange: (weightVal) {
                        _weight = weightVal;
                      },
                      title: "Weight(Kg)",
                      initValue: 60,
                      min: 0,
                      max: 200)
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              // Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: CustomButton(
                  label: "Calculate",
                  onPressed: () async {
                    calculateBmi();
                    await Navigator.push(
                        context,
                        PageTransition(
                            child: ScoreScreen(
                              bmiScore: _bmiScore,
                              age: _age,
                            ),
                            type: PageTransitionType.fade));
                  },
                ),

                // SwipeableButtonView(
                //   isFinished: _isFinished,
                //   onFinish: () async {
                //     await Navigator.push(
                //         context,
                //         PageTransition(
                //             child: ScoreScreen(
                //               bmiScore: _bmiScore,
                //               age: _age,
                //             ),
                //             type: PageTransitionType.fade));

                //     setState(() {
                //       _isFinished = false;
                //     });
                //   },
                //   onWaitingProcess: () {
                //     //Calculate BMI here
                //     calculateBmi();

                //     Future.delayed(Duration(seconds: 1), () {
                //       setState(() {
                //         _isFinished = true;
                //       });
                //     });
                //   },
                //   activeColor: Colors.grey,
                //   buttonWidget: const Icon(
                //     Icons.arrow_forward_ios_rounded,
                //     color: Colors.blue,
                //   ),
                //   buttonText: "CALCULATE",
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
