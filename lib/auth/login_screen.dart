import 'package:darth_runner/auth/forgot_pass.dart';
import 'auth_service.dart';
import 'signup_screen.dart';
import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final AuthService auth;
  const LoginScreen({super.key, required this.auth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = true;
  String _errorMessage = '';

  @override
  void dispose() {
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text("Login",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  const SizedBox(height: 50),
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
                    controller: _password,
                    isPassword: true,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassword()));
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )),
                  const SizedBox(height: 30),

                  //login button
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : CustomButton(
                          label: "Login",
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await login();
                            setState(() {
                              _isLoading = false;
                            });
                          }),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: _isSuccess
                        ? const Text("")
                        : Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                  const SizedBox(height: 10),
                  // isLoading
                  //     ? const CircularProgressIndicator()
                  //     : CustomButton(
                  //         label: "Sign In with Google",
                  //         onPressed: () async {
                  //           setState(() {
                  //             isLoading = true;
                  //           });
                  //           await _auth.loginWithGoogle();
                  //           setState(() {
                  //             isLoading = false;
                  //           });
                  //         },
                  //       ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () => goToSignup(context),
                        child: const Text("Sign Up",
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

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  login() async {
    //await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);
    await widget.auth
        .loginUserWithEmailAndPassword(_email.text, _password.text);
    setState(() {
      _isSuccess = false;
    });
    _errorMessage = '';
    _errorMessage += "Please enter valid credentials";
  }
}
