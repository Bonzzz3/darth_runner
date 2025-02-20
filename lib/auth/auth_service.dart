import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // SEND EMAIL VERIFICATION LINK TO USER EMAIL

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      log(e.toString());
    }
  }

  // SEND PASSWORD RESET LINK TO EMAIL PROVIDED

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
    }
  }

  // CREATE A NEW USER WITH EMAIL, PASSWORD AND USER DISPLAY NAME

  Future<User?> createUserWithUsernameEmailAndPassword(
      String username, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user!.updateDisplayName(username);
      _firestore.collection("Users").doc(email).set({
        'username': username,
        'bio': 'Empty bio..',
        'doneOnboarding': false,
      });
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  // SIGN IN WITH USER EMAIL AND PASSWORD

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  // SIGN OUT USER

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }

  // SOME COMMON EXCEPTIONS TO HANDLE
  exceptionHandler(String code) {
    switch (code) {
      case "invalid-credential":
        log("Your login credentials are invalid");
      case "weak-password":
        log("Your password must be at least 8 characters");
      case "email-already-in-use":
        log("User already exists");
      default:
        log("Something went wrong");
    }
  }
}
