import 'package:flutter/material.dart';

class StatsDisplay extends StatelessWidget {
  const StatsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration:const BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // begin: Alignment(-1,-1),
            // end: Alignment(0.7,1),
            colors: [
              Color.fromARGB(255, 6, 4,120),
              Color.fromARGB(255, 174, 12,0)],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child:
               AppBar(
                  backgroundColor: Colors.transparent,
                  // elevation: 0,
                  title: const Text('YOUR STATS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
                
              ),
            ),
          
        ],        
      )
    );
  }
}