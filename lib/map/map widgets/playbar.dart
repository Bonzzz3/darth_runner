import 'package:darth_runner/pages/navigation.dart';
import 'package:flutter/material.dart';

class Playbar extends StatefulWidget {
  const Playbar({super.key});

  @override
  State<Playbar> createState() => _PlaybarState();
}

class _PlaybarState extends State<Playbar> {

  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //play and pause Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            fixedSize: const Size.square(50),
            iconColor: const Color.fromARGB(255, 0, 0, 0)  ,
            backgroundColor: Colors.grey
                     
          ),
          onPressed: () {
            setState(() {
              isRunning = !isRunning;
              // if (isRunning) {
              //   startTracking();
              // } else {
              //   pauseTracking();
              // }
            });
          } ,
          child: Icon(
            isRunning ? Icons.pause : Icons.play_arrow_sharp,          
            ),
          ),
        // stop button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            iconColor: Colors.black,
            backgroundColor: Colors.grey,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            fixedSize: const Size.square(50),
          ),
          onPressed:() {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const NotHomePage()
                        )
                      );
                  },
          child: const Icon(
            Icons.stop,
          )
        )
      ],
    );
  }
}

// void pauseTracking() {

// }

// void startTracking() {
  
// }