import 'dart:async';

import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/widgets/button.dart';
import 'package:darth_runner/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required User user});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = AuthService();
  late Timer timer;
  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerificationLink();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        timer.cancel();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Wrapper(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "We have sent an email for verification. If you did not receive an email, please tap on resend.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: "Resend Email",
                      onPressed: () async {
                        _auth.sendEmailVerificationLink();
                      },
                    ),
                  ],
                ))));
  }
}
