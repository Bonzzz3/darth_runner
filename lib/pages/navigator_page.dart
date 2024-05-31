import 'package:darth_runner/components/bottom_nav_bar.dart';
import 'package:darth_runner/pages/profile.dart';
import 'package:darth_runner/pages/run.dart';
import 'package:darth_runner/pages/home.dart';
import 'package:flutter/material.dart';

class NotHomePage extends StatefulWidget {
  const NotHomePage({super.key});

  @override
  State<NotHomePage> createState() => _NotHomePageState();
}

class _NotHomePageState extends State<NotHomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }  

  final List<Widget> _pages = [
    const HomePage(),
    const Run(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 172, 12, 0),
    
      body: _pages[_selectedIndex],
      bottomNavigationBar:  MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index) ,
        onTap: (index) => navigateBottomBar(index) ,
      ),
      
    )
    ;
  }
}