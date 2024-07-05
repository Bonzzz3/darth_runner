import 'package:darth_runner/database/rundata.dart';
import 'package:darth_runner/map/map_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class Run extends StatefulWidget {
  const Run({super.key});

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> {
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
               Positioned(
              top: 100,
              left: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(
                          builder: (context) => const MapPage()
                    )
                  );
                },
                child: const Text('start running')),
            ), 
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Rundata>('runDataBox').listenable(), 
                  builder: (context, Box<Rundata> box, _) {
                    if (box.values.isEmpty) {
                      return const Center(
                        child: Text('No Runs Recorded'),
                      );
                    }
                    final runs = box.values.toList().reversed.toList();
                    debugPrint('${runs.length}');
                    return ListView.builder(
                      
                      itemCount: runs.length,
                      itemBuilder: (context, index){
                        Rundata runData = runs[index];
                        // String formattedDate = DateFormat('EEE, M/d/y').format((runData.hiveDate)) ;
                        return Card(
                          child: ListTile(
                            title: Text(runData.hiveRunTitle),
                            subtitle: Text(
                              'Date: ${DateFormat('EEE, d/M/y').format(runData.hiveDate)}\n'
                              'Distance: ${runData.hiveDistance} km\n'
                              'Time: ${runData.hiveTime}'
                            ),
                          ),
                        );
                      },
                    );
                }
                  
                  )
              )
            ],
          ), 
        
          

        ],        
      )
    ); 
  }
}


