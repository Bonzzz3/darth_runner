import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: const Text('Home',
        style: TextStyle(
          fontWeight: FontWeight.bold,

        ),),
      ),
      body: Center(
        child: Text('home page'),
      ),
    );
  }
}