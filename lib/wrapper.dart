import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/auth/login_screen.dart';
import 'package:darth_runner/auth/verification_screen.dart';
import 'package:darth_runner/onboarding/intro1.dart';
import 'package:darth_runner/pages/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<bool?> _getIsOnboarded(String email) async {
    try {
      final documentSnapshot =
          await FirebaseFirestore.instance.collection("Users").doc(email).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.get("doneOnboarding");
      }
    } catch (e) {
      log('Error fetching doneOnboarding value: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              } else {
                if (snapshot.data == null) {
                  return LoginScreen(
                    auth: AuthService(),
                  );
                } else {
                  if (snapshot.data!.emailVerified == true) {
                    //return const IntroPage();
                    // final currentUser = FirebaseAuth.instance.currentUser!;
                    // final usersCollection =
                    //     FirebaseFirestore.instance.collection("Users");
                    // final documentSnapshot =
                    //     usersCollection.doc(currentUser.email).get();
                    // final isOnboarded = documentSnapshot.get("isOnboarded");
                    //.get('doneOnboarding');
                    final currentUser = FirebaseAuth.instance.currentUser!;
                    return FutureBuilder<bool?>(
                      future: _getIsOnboarded(currentUser.email!),
                      builder: (context, onboardedSnapshot) {
                        if (onboardedSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (onboardedSnapshot.hasError) {
                          return const Center(
                            child: Text("Error fetching onboarded status"),
                          );
                        } else if (onboardedSnapshot.data == true) {
                          return const NotHomePage();
                        } else {
                          return const Intro1();
                        }
                      },
                    );
                    //return showHome ? const NotHomePage() : const Intro1();
                  } else {
                    return VerificationScreen(
                      user: snapshot.data!,
                    );
                  }
                }
              }
            }));
  }
}
