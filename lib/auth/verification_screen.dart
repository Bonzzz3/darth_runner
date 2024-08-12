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

  // CHECK IF USER HAS VERIFIED THEIR EMAIL
  // IF VERIFIED, PAGE IS REDIRECTED TO THE WRAPPER PAGE TO CHECK FOR USER AUTHENTICATION CHANGES

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Wrapper())),
            FirebaseAuth.instance.currentUser?.delete(),
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/galaxy.jpeg"), fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              // INSTRUCTIONS TO VERIFY EMAIL AND A BUTTON TO RECEIVE A NEW VERIFICATION LINK
              children: [
                const Text(
                  "We have sent an email for verification. You will only be able to proceed after verifying.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const Text(
                  "Please wait for a few seconds for the screen to reload after verifying and DO NOT PRESS THE BACK BUTTON. If you did not receive an email, please tap on resend.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: "Resend Email",
                  onPressed: () async {
                    _auth.sendEmailVerificationLink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
