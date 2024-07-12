import 'package:darth_runner/onboarding/intro2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro1 extends StatefulWidget {
  const Intro1({super.key});

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
  String _gender = "";
  final List<DropdownMenuEntry<String>> _genderlist = [
    const DropdownMenuEntry(value: "Male", label: "Male"),
    const DropdownMenuEntry(value: "Female", label: "Female"),
    const DropdownMenuEntry(
        value: "Prefer not to say", label: "Prefer not to say"),
  ];

  @override
  void initState() {
    super.initState();
    _loadGender();
  }

  Future<void> _loadGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _gender = prefs.getString('gender') ?? "Male";
    });
  }

  Future<void> _saveGender(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', gender);
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
              "Before you begin..",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              "Select your gender",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            DropdownMenu<String>(
              initialSelection: _gender,
              textStyle: const TextStyle(color: Colors.white),
              trailingIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              )),
              dropdownMenuEntries: _genderlist,
              onSelected: (gender) {
                if (gender != null) {
                  setState(() {
                    _gender = gender;
                  });
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                _saveGender(_gender);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro2()),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text(
                "Proceed",
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

// void main() {
//   runApp(const MaterialApp(
//     home: Intro1(),
//   ));
// }
