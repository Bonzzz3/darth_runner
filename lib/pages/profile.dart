import 'package:darth_runner/auth/auth_service.dart';
import 'package:darth_runner/auth/login_screen.dart';
// import 'package:darth_runner/home_screen.dart';
import 'package:darth_runner/widgets/button.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
            CustomButton(
              label: "Sign Out",
              onPressed: () async {
                await auth.signout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            )
            
          ],
        )
      ],
    ));
  }
}
