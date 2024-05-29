import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return GNav(
        color: const Color.fromARGB(255, 11, 10, 10),
        activeColor: const Color.fromARGB(255, 32, 2, 59),
        tabActiveBorder: Border.all(style:BorderStyle.none),
        tabBackgroundColor: const Color.fromARGB(255, 173, 153, 227),
        mainAxisAlignment: MainAxisAlignment.center,
        iconSize: 25,
        tabBorderRadius: 20,
        rippleColor: const Color.fromARGB(255, 30, 5, 76),
        curve: Curves.bounceIn,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 20),
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
        GButton(
          icon: Icons.home,
          text: '  HOME',
        ),
        GButton(
          icon: Icons.run_circle_outlined,
          text: '  RUN',
        ),
        GButton(
          icon: Icons.person,
          text: '  PROFILE',
        ),
      ]
      );
  }
}