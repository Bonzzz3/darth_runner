import 'auth_service.dart';
import 'login_screen.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _isValid = false;
  String _errorMessage = '';

  // FUNCTION TO VALIDATE NAME, EMAIL AND PASSWORD

  bool _validateFields(String name, String email, String password) {
    
    // RESET ERROR MESSAGE.

    _errorMessage = '';

    if (name.isEmpty) {
      _errorMessage += 'Enter a valid username.\n';
    }

    if (!EmailValidator.validate(email)) {
      _errorMessage += 'Enter a valid Email.\n';
    }
    //PASSWORD LENGTH MUST BE ATLEAST 8 CHARAFCTERS LONG.

    if (password.length < 8) {
      _errorMessage += 'Password must be at least 8 characters.\n';
    }

    //IF THERE ARE NO ERROR MESSAGES THE PASSWORD IS VALID.
    return _errorMessage.isEmpty;
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                // USERNAME, EMAIL AND PASSWORD TEXT FIELD, SIGN UP BUTTON AND LOGIN NAV BUTTON

                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Center(
                    child: Text("Sign Up",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Note: Username cannot be changed after signing up",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hint: "Enter Username",
                    label: "Username",
                    controller: _name,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Email",
                    label: "Email",
                    controller: _email,
                    isEmail: true,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hint: "Enter Password",
                    label: "Password",
                    isPassword: true,
                    controller: _password,
                  ),
                  const SizedBox(height: 30),

                  // SIGNUP BUTTON AND VALIDATE BEFORE CREATING USER ACCOUNT

                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : CustomButton(
                            label: "Signup",
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              setState(() {
                                _isValid = _validateFields(
                                    _name.text, _email.text, _password.text);
                              });
                              if (_isValid) {
                                await _signup();
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => goToLogin(context),
                        child: const Text("Login",
                            style: TextStyle(color: Colors.red)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // NAVIGATE TO LOGIN PAGE

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen(
                  auth: AuthService(),
                )),
      );

  // CREATE NEW USER
  
  _signup() async {
    await _auth.createUserWithUsernameEmailAndPassword(
        _name.text, _email.text, _password.text);
    Navigator.pop(context);
  }
}
