import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darth_runner/auth/auth_service.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersCollection = FirebaseFirestore.instance.collection("Users");

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

    //update in Firestore
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Stack(
                  //clipBehavior: Clip.hardEdge,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // begin: Alignment(-1,-1),
                          // end: Alignment(0.7,1),
                          colors: [
                            Color.fromARGB(255, 6, 4, 120),
                            Color.fromARGB(255, 174, 12, 0)
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        //title
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          title: const Text(
                            'Your Profile',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //profile picture
                            const Center(
                              child: Icon(
                                Icons.person,
                                size: 72,
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            //user email
                            Center(
                              child: Text(
                                currentUser.email!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            //details
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                'My Details',
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 20),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            MyTextBox(
                              text: userData['username'],
                              sectionName: 'username',
                              onPressed: () => editField("username"),
                            ),

                            MyTextBox(
                              text: userData['bio'],
                              sectionName: 'bio',
                              onPressed: () => editField("bio"),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 100,
                        ),
                        // Signout button
                        CustomButton(
                          label: "Sign Out",
                          onPressed: () async {
                            await auth.signout();
                            Phoenix.rebirth(context);
                          },
                        )
                      ],
                    )
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
            }));
  }
}
