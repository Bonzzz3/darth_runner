import 'package:darth_runner/onboarding/intro1.dart';
import 'package:darth_runner/onboarding/intro3.dart';
import 'package:darth_runner/widgets/text_fill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro2 extends StatefulWidget {
  const Intro2({super.key});

  @override
  State<Intro2> createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {
  String _age = "";
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isValid = false;
  String _errorMessage = '';

  bool _validateAge(String age) {
    // Reset error message
    _errorMessage = '';
    final tempAge = int.tryParse(age);

    if (tempAge == null) {
      _errorMessage += 'Please enter a valid age.\n';
    } else if (tempAge > 150) {
      _errorMessage += "Hmm, I've never seen anyone live to that age..\n";
    } else if (tempAge < 3) {
      _errorMessage += "Young warrior, you are not old enough yet..\n";
    }

    return _errorMessage.isEmpty;
  }

  Future<void> _loadAge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _age = prefs.getString('age') ?? "";
      _controller.text = _age;
    });
  }

  Future<void> _saveAge(String age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('age', age);
  }
  
  @override
  void initState() {
    super.initState();
    _loadAge();
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
              "Age",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 120, right: 120),
              child: TextFill(
                controller: _controller,
                hintText: "Age",
                obscureText: false,
                textInputType: TextInputType.number,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),

            const SizedBox(
              height: 10,
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

            // Proceed button + validate
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : TextButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                          _isValid = _validateAge(_controller.text);
                        });
                        if (_isValid) {
                          setState(() {
                            _age = _controller.text;
                            _isLoading = false;
                          });
                          await _saveAge(_age);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Intro3()),
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text(
                        "Proceed",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            ),

            // Back button
            TextButton(
              onPressed: () async {
                setState(() {
                  _age = _controller.text;
                });
                await _saveAge(_age);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Intro1()),
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
