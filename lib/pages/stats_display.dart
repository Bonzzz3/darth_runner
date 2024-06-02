import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StatsDisplay extends StatefulWidget {
  const StatsDisplay({super.key});

  @override
  State<StatsDisplay> createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay> {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
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
          Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  
                  child: TableCalendar(
                    focusedDay: today,
                     firstDay: DateTime.utc(2020,1,1), 
                     lastDay: DateTime.utc(2030,12,31),
                     headerVisible: true,
                     headerStyle: const HeaderStyle(
                      titleCentered: true,
                      
                      ),  
                  ),
                ),
              ),
                  
              ]
              ),
            ],
          ) 
      );
  }
}