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

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
        body: Stack(
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colors.grey[300], fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),

                MyTextBox(
                  text: 'darth',
                  sectionName: 'username',
                  onPressed: () => editField('username'),
                ),

                MyTextBox(
                  text: 'empty bio',
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
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
    ));
  }
}
