import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Run extends StatelessWidget {
  const Run({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          //elevation: 0,
          title: const Text(
            "Let's Run",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          //centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 25,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/gradient.png"),
                fit: BoxFit.cover),
          ),
          child: SafeArea(
              child: Column(
            children: [PedometerApp()],
          )),
        ));
  }
}

class PedometerApp extends StatefulWidget {
  @override
  _PedometerAppState createState() => _PedometerAppState();
}

class _PedometerAppState extends State<PedometerApp> {
  late Stream<StepCount> _stepCountStream;
  String _status = 'unknown';
  int _dailySteps = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _prefs = await SharedPreferences.getInstance();
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onStepCountError);
    _resetStepsAtMidnight();
  }

  void _onStepCount(StepCount event) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastSavedDay = _prefs.getString('lastSavedDay') ?? today;

    if (today != lastSavedDay) {
      _dailySteps = event.steps;
      _prefs.setString('lastSavedDay', today);
    } else {
      _dailySteps = event.steps - (_prefs.getInt('stepsAtMidnight') ?? 0);
    }

    setState(() {
      _dailySteps = _dailySteps < 0 ? 0 : _dailySteps;
    });

    _prefs.setInt('stepsAtMidnight', event.steps - _dailySteps);
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void _resetStepsAtMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final durationUntilMidnight = midnight.difference(now);

    Future.delayed(durationUntilMidnight, () {
      _prefs.setInt('stepsAtMidnight', _dailySteps);
      _prefs.setString(
          'lastSavedDay', DateFormat('yyyy-MM-dd').format(DateTime.now()));
      _resetStepsAtMidnight();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 40,
        ),
        const Text(
          'Steps taken today:',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        Text(
          '$_dailySteps',
          style: const TextStyle(
              fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(home: PedometerApp()));
