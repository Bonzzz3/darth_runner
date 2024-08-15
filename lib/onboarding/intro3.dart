import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/onboarding/intro2.dart';
import 'package:darth_runner/onboarding/welcome_page.dart';
import 'package:darth_runner/widgets/text_fill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro3 extends StatefulWidget {
  const Intro3({super.key});

  @override
  State<Intro3> createState() => _Intro3State();
}

class _Intro3State extends State<Intro3> {
  String _height = "";
  String _weight = "";
  final TextEditingController _heightCon = TextEditingController();
  final TextEditingController _weightCon = TextEditingController();
  bool _isLoading = false;
  bool _isValid = false;
  String _errorMessage = '';
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  bool _validateHeightWeight(String height, String weight) {

    // RESET ERROR MESSAGE.

    _errorMessage = '';
    final tempHeight = int.tryParse(height);
    final tempWeight = int.tryParse(weight);

    if (tempHeight == null) {
      _errorMessage += 'Please enter a valid height.\n';
    } else if (tempHeight > 260) {
      _errorMessage += "Please enter a valid height.\n";
    } else if (tempHeight < 50) {
      _errorMessage += "Please enter a valid height.\n";
    }

    if (tempWeight == null) {
      _errorMessage += 'Please enter a valid weight.\n';
    } else if (tempWeight > 700) {
      _errorMessage += "Please enter a valid weight.\n";
    } else if (tempWeight < 10) {
      _errorMessage += "Please enter a valid weight.\n";
    }
    return _errorMessage.isEmpty;
  }

  // FUNCTION TO GET HEIGHT AND WEIGHT

  Future<void> _loadHeightWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _height = prefs.getString('height') ?? "";
      _weight = prefs.getString('weight') ?? "";
      _heightCon.text = _height;
      _weightCon.text = _weight;
    });
  }

  // FUNCTION TO SAVE HEIGHT AND WEIGHT.

  Future<void> _saveHeightWeight(String height, String weight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('height', height);
    prefs.setString('weight', weight);
  }

  // TO SAVE TO FIREBASE

  void _saveToFirebase(String gender, String age, String height, String weight,
      bool doneOnboarding) {
    usersCollection.doc(currentUser.email).update({
      'Gender': gender,
      'Age': age,
      'Height': height,
      'Weight': weight,
      'doneOnboarding': doneOnboarding,
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHeightWeight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/galaxy.jpeg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Height in cm",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 120, right: 120),
              child: TextFill(
                controller: _heightCon,
                hintText: "Height",
                obscureText: false,
                textInputType: TextInputType.number,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Weight in kg",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 120, right: 120),
              child: TextFill(
                controller: _weightCon,
                hintText: "Weight",
                obscureText: false,
                textInputType: TextInputType.number,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: _isValid
                  ? const Text("")
                  : Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),

            // SUBMIT BUTTON + SAVE TO FIREBASE

            Center(
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                          _isValid = _validateHeightWeight(
                              _heightCon.text, _weightCon.text);
                        });
                        if (_isValid) {
                          setState(() {
                            _height = _heightCon.text;
                            _weight = _weightCon.text;
                            _isLoading = false;
                          });
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await _saveHeightWeight(_height, _weight);
                          _saveToFirebase(
                              prefs.getString('gender') ?? "",
                              prefs.getString('age') ?? "",
                              _height,
                              _weight,
                              true);
                          await prefs.clear();
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IntroPage()),
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            ),

            // BACK BUTTON
            
            TextButton(
              onPressed: () async {
                setState(() {
                  _height = _heightCon.text;
                  _weight = _weightCon.text;
                });
                await _saveHeightWeight(_height, _weight);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro2()),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text(
                "Back",
                style: TextStyle(fontSize: 20),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
