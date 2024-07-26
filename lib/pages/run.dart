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
  bool isPageActive = false;
  Box<Rundata>? _box;
  int currentPage = 1;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isPageActive = true;
        _box = Hive.box<Rundata>('runDataBox');
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      
      appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Run',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), 
      extendBodyBehindAppBar: true,
      body: Stack(
        children:[
           Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 6, 4, 120),
                  Color.fromARGB(255, 174, 12, 0),
                ],
              ),
            ),
           ), 
          isPageActive
              ? Column(
                  children: [                 
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box<Rundata>('runDataBox').listenable(),
                       builder: (context, Box<Rundata> box, _){
                        // LAZY LOADING
                        final fetchedRuns = box.values 
                          .toList()
                          .reversed
                          .skip((currentPage -1) *10)
                          .take(10)
                          .toList();
        
                        if (fetchedRuns.isEmpty && currentPage > 1) {
                          // NO MORE RUNS TO LOAD
                          return const Center(
                            child: Text('No More Runs'),
                          );
                        } else if (fetchedRuns.isEmpty){
                          // NO RUNS
                          return const Center(
                            child: Text('No Runs Recorded'),
                          );
                        } 
                        return ListView.builder(
                        itemCount:  fetchedRuns.length,
                        itemBuilder: (context, index) {
                        Rundata runData = fetchedRuns[index];
        
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: LinearGradient(
                                  colors: [Colors.lightBlueAccent[100]!, Colors.lightBlueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              title: Text(runData.hiveRunTitle),
                              subtitle: Text(
                                  'Date: ${DateFormat('EEE, d/M/y').format(runData.hiveDate)}\n'
                                  'Distance: ${runData.hiveDistance} km\n'
                                  'Time: ${runData.hiveTime}', style: TextStyle(fontWeight:FontWeight.bold),
                              ),
                            ),
                          ),
                        );}
                        
                        );
                       }
        
                      
                      ) 
                    )
                  ]
              )
              
        : const Center(
            child: Text('Loading'),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            elevation: 20,
            child: const Icon(Icons.directions_run_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage()
                ));
            }
            )
        ) 
            ]),
      ); 
  }
}


