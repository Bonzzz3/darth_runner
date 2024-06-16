import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      log("Something went wrong");
      print(e.toString());
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(TextEditingController username,
      TextEditingController email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.text, password: password);
      await cred.user!.updateDisplayName(username.text);
      log(username.text);
      FirebaseFirestore.instance.collection("Users").doc(cred.user!.email).set({
        'username': username.text,
        'bio': 'Empty bio..',
      });
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

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

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }

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
