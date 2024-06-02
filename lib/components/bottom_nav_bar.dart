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
   Container(
    color:Colors.black,
     child: Padding(
       padding: const EdgeInsets.all(5),
       child: GNav(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        tabActiveBorder: Border.all(style:BorderStyle.none),
        tabBackgroundColor: const Color.fromARGB(255, 45, 44, 44),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        activeColor: Colors.white,
        iconSize: 25,
        tabBorderRadius: 30,
        rippleColor: const Color.fromARGB(255, 30, 5, 76),
        curve: Curves.bounceIn,
        duration: const Duration(milliseconds: 300),
        onTabChange: (value) => onTabChange!(value),
        gap:  8,
            tabs: const [
            GButton(
              icon: Icons.home,
              text: 'HOME',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            GButton(
              icon: Icons.run_circle_outlined,
              text: 'RUN',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            GButton(
              icon: Icons.bar_chart_sharp,
              text: 'STATS',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            GButton(
              icon: Icons.person,
              text: 'PROFILE',
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ]
          ),
     ),
   );
  }
}