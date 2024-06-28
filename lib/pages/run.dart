import 'package:darth_runner/map/map_page.dart';
import 'package:flutter/material.dart';

class Run extends StatelessWidget {
  const Run({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //REMOVE STACK 
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
          
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Lets Run',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ), 
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(
                        builder: (context) => const MapPage()
                  )
                );
              },
              child: const Text('start running')),
          )
        ],        
      )
    ); 
  }
}


