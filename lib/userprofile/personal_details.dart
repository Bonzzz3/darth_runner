import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          'Your Personal Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 25,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: usersCollection.doc(currentUser.email).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //gender

                          //height

                          //weight
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error${snapshot.error}'),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
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
