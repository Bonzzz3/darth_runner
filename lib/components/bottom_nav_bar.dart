import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


//convert to statefulwidget when implementing navbar colour
class MyBottomNavBar extends StatelessWidget {

  void Function(int)? onTabChange;
  void Function(int)? onTap;
  MyBottomNavBar({super.key, 
  required this.onTabChange,
  required this.onTap});

  @override
  Widget build(BuildContext context) {
   return 
  //test using default flutter bar
  //  BottomNavigationBar(
  //   // elevation: 0,
  //   onTap: (value) => onTap!(value),
  //   selectedItemColor: Colors.black,
  //   unselectedItemColor: Colors.grey,
  //   selectedFontSize: 17,
  //   items: const [
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.home),
  //       label: ' HOME'
  //       ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.run_circle_outlined),
  //       label: ' RUN'
  //       ),
  //     BottomNavigationBarItem(
  //       icon: Icon(Icons.person),
  //       label: ' PROFILE'
  //       )
  //     ], 
  //    );
   
   
  //test using google bar
   GNav(
        color: const Color.fromARGB(255, 11, 10, 10),
        activeColor: const Color.fromARGB(255, 32, 2, 59),
        tabActiveBorder: Border.all(style:BorderStyle.none),
        tabBackgroundColor: const Color.fromARGB(255, 203, 64, 64),
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