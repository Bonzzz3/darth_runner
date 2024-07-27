import 'package:cached_network_image/cached_network_image.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isPageActive = true;
        _box = Hive.box<Rundata>('runDataBox');
      });
    });
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
        children: [
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
                        builder: (context, Box<Rundata> box, _) {
                          // LAZY LOADING
                          final fetchedRuns = box.values
                              .toList()
                              .reversed
                              .skip((currentPage - 1) * 10)
                              .take(10)
                              .toList();

                          if (fetchedRuns.isEmpty && currentPage > 1) {
                            // NO MORE RUNS TO LOAD
                            return const Center(
                              child: Text('No More Runs'),
                            );
                          } else if (fetchedRuns.isEmpty) {
                            // NO RUNS
                            return const Center(
                              child: Text('No Runs Recorded'),
                            );
                          }

                          return ListView.builder(
                            itemCount: fetchedRuns.length,
                            itemBuilder: (context, index) {
                              Rundata runData = fetchedRuns[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        runData.snapshotUrl != null && runData.snapshotUrl!.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: runData.snapshotUrl!,
                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                                              ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                runData.hiveRunTitle,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                'Date: ${DateFormat('EEE, d/M/y').format(runData.hiveDate)}',
                                                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 45, 43, 43)),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                'Distance: ${runData.hiveDistance} km',
                                                style: TextStyle(fontSize: 14, color:Color.fromARGB(255, 45, 43, 43)),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                'Time: ${runData.hiveTime}',
                                                style: TextStyle(fontSize: 14, color:Color.fromARGB(255, 45, 43, 43)),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                'Pace: ${runData.hivePace.toStringAsFixed(2)}',
                                                style: TextStyle(fontSize: 14, color:Color.fromARGB(255, 45, 43, 43)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
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
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
