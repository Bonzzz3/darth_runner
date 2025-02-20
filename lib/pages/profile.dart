import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:darth_runner/achievements/achievements_page.dart';
import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/userprofile/personal_details.dart';
import 'package:darth_runner/widgets/button.dart';
import 'package:darth_runner/widgets/text_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final auth = AuthService();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  bool _isLoading = false;

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    //UPDATE IN FIRESTORE
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
        automaticallyImplyLeading: false,
        titleSpacing: 25,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/gradient red blue wp.png"),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: usersCollection.doc(currentUser.email).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // PROFILE PICTURE
                          const Center(
                            child: Icon(
                              Icons.person,
                              size: 72,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // USER EMAIL
                          Center(
                            child: Text(
                              currentUser.email!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // PERSONAL DETAILS
                          Center(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PersonalDetails()));
                              },
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll<Color>(Colors.grey),
                              ),
                              child: const Text(
                                "Edit personal details",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // DETAILS
                          Text(
                            'My Details',
                            style: TextStyle(
                                color: Colors.grey[300], fontSize: 20),
                            textAlign: TextAlign.left,
                          ),

                          // MyTextBox(
                          //   text: userData['username'],
                          //   sectionName: 'username',
                          //   onPressed: () {
                          //     //editField("username");
                          //     // currentUser.updateDisplayName("");
                          //   },
                          // ),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding:
                                  const EdgeInsets.only(left: 15, bottom: 15),
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "username",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    userData['username'],
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              )),

                          MyTextBox(
                            text: userData['bio'],
                            sectionName: 'bio',
                            onPressed: () => editField("bio"),
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // ACHIEVEMENTS
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                child: const Text(
                                  "My achievements",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AchievementsHomePage()));
                                },
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 80,
                          ),

                          // SIGNOUT BUTTON
                          Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : CustomButton(
                                    label: "Sign Out",
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await auth.signout();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Phoenix.rebirth(context);
                                    },
                                  ),
                          ),
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
