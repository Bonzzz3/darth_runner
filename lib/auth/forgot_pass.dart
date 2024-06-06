import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/widgets/button.dart';
import 'package:darth_runner/widgets/textfield.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/Wallpaper.jpeg"),
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter email to send you a password reset email",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    controller: _email, hint: "Enter Email", label: "Email"),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  label: "Send Email",
                  onPressed: () async {
                    await _auth.sendPasswordResetLink(_email.text);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "An email for password reset has been sent to your email")));
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
