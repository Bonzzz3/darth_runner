import 'dart:async';
import 'package:darth_runner/database/rundata.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:darth_runner/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  
  // POSITION VARIABLES
  static const LatLng _towngreen = LatLng(1.3051320676351397, 103.77317545254137);
  LatLng? currentPosition;

  // POLYLINE SET AND LIST OF LAT AND LONG FOR PLACES BEEN.
  List<LatLng> polyLineCoordinates = [];
  List<LatLng> polyDisplay = [];
  Set<Polyline> polyLine = {};

  // CREATING INSTANCE OF STOPWATCH.
  final StopWatchTimer stopWatch = StopWatchTimer();

  // CREATING CONTROLLERS.
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  Location locationController = Location();

  // PLAY PAUSE STATE.
  bool isRunning = false;

  // VARIABLES FOR DISTANCE TRACKING.
  double distanceTravelled = 0.0;
  double appendDist = 0.0;

  // VARIABLES FOR STOPWATCH.
  late String displayTime;


  int currentTime = 0;
  int lastTime = 0;
  double pace = 0.0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.
    addPostFrameCallback((_) async => await fetchLocation());
  }

  @override
  void dispose() async {
    super.dispose();
    await stopWatch.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null?
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Text('Ensure your location is turned on')
              ],
            )
            
          // ? const Center(
          //   child: CircularProgressIndicator()
          //   )
      :Stack(
        children: [
          GoogleMap(
          onMapCreated: (GoogleMapController controller) => mapController.complete(controller),

          // SETS INITIAL CAMERA POSITION.
          initialCameraPosition: const CameraPosition(
            target: _towngreen, // MIGHT SHOW USER CURRENT LOCATION IMMEDIATELY SO REDUNDANT CODE.
            zoom: 16, 
          ),
          markers: {
            Marker(
              markerId: const MarkerId('currentLocation'),
              icon: BitmapDescriptor.defaultMarker, // EDIT ICON OF USER POSITION.
              position: currentPosition!
              )
          },
          polylines: polyLine,
        ),
  
        // CONTAINER SHOWING STATS OF THE RUN.
        Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  spreadRadius: 5,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(9),
                        child: Text('Pace min/km',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                      ),
                      Text((pace).toStringAsFixed(2),
                       style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                       ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(9),
                        child: Text('Time',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                      ),
                      StreamBuilder<int>(
                          stream: stopWatch.rawTime,
                          initialData: 0,
                          builder: (context, snap) {
                            currentTime = snap.data!;
                            displayTime =
                                '${StopWatchTimer.getDisplayTimeHours(currentTime)}:${StopWatchTimer.getDisplayTimeMinute(currentTime)}:${StopWatchTimer.getDisplayTimeSecond(currentTime)}';
                            return Text(displayTime,
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    )
                                );})
  
                   ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(9),
                        child: Text('Distance km',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                      ),
                      Text((distanceTravelled / 1000).toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            )
                      )
                    ],
                  ),
                ],
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
                height: 29,
                thickness: 5,
                color: Colors.black
                ,
              ), //add parameters
              // const SizedBox(
                
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  //PLAY AND PAUSE BUTTON

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        fixedSize: const Size.square(75),
                        iconColor: const Color.fromARGB(255, 0, 0, 0)  ,
                        backgroundColor: Colors.grey
                                
                      ),
                      onPressed: () {
                        setState(() {
                          isRunning = !isRunning;
                          if (isRunning) {
                            stopWatch.onStartTimer();
                          }
                          else {
                            polyLineCoordinates.clear();
                            stopWatch.onStopTimer();
                          }
                        });
                      } ,
                      child: Icon(
                        isRunning ? Icons.pause : Icons.play_arrow_sharp,    
                        size: 40,      
                        ),
                      ),
                  ),
          
                  // STOP BUTTON

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.black,
                      backgroundColor: Colors.grey,
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      fixedSize: const Size.square(75),
                    ),
                    onPressed:() {
                      stopRunning();
                            },
                    child: const Icon(
                      Icons.stop,
                      size: 40,
                                  )
                                )
                    ],
                  )
                ],
              ),
            )
          )
        ],
      )
    );  
  }


  // FUNCTION ON STOP BUTTON PRESSED TO STORE DATA IN HIVE.

  void stopRunning() async {
    String? runTitle = await showTitleDialog(context);
    runTitle ??= '';
    var box = Hive.box<Rundata>('runDataBox');
    var runData = Rundata(
      hiveDistance: double.parse((distanceTravelled / 1000).toStringAsFixed(2)) ,
      hiveDate: DateTime.now(),
      hiveTime: displayTime, 
      hivePace: pace, 
      hiveRunTitle: runTitle);
    await box.add(runData);
    
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<String?> showTitleDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Enter Your Run Title'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              }, 
              child: const Text('Save'))
          ],
        );
      }
      );
  }

  // FUNCTION TO CENTER THE USER LOCATION ON THE MAP.

  Future<void> cameraToPosition (LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 16, // OPTIMIZE ZOOM VALUE
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition ));
  }

  
  // FUNCTION TO FETCH LOCATION.
  // CHECKS IF LOCATION SERVICES ARE ENABLED AND REQUESTS IF NECESSARY.

  Future<void> fetchLocation() async{

    // INITIALIZING VARIABLES.
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    }
    else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // LISTENER THAT GETS CURRENT POSITION LAT AND LONG.
    
    locationController.onLocationChanged.listen((LocationData currentLocation) {

      LatLng loc = LatLng(currentLocation.latitude!,currentLocation.longitude!);

      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {

          // SETS CURRENT POSITION 

          currentPosition = 
            LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!);

          // ADD CURRENT POSITION TO ROUTE TRAVELLED (!!!! ONLY IF PLAY BUTTON ACTIVE).

          if (isRunning) {
            polyLineCoordinates.add(currentPosition!);
            
          }
          polyDisplay.add(currentPosition!);

          // ADD POLYLINE TO SET.

          polyLine.add(
            Polyline(
              polylineId: const PolylineId('beenHere'),
              points: polyDisplay,
              width: 6,
              color: isRunning? Colors.deepPurpleAccent: Colors.blueGrey, // can make this a customizable feature.
            ) 
          );

          // CENTERING THE CAMERA ON LOCATION CHANGE.
          
          cameraToPosition(currentPosition!); 

          // FUNCTION TO CALCULATE THE DISTANCE TRAVELLED WHILE PLAY BUTTON ACTIVE.

          if (isRunning) {
            if (polyLineCoordinates.length >= 2)  {
              LatLng secondLastLocation = polyLineCoordinates[polyLineCoordinates.length-2];
              appendDist =  Geolocator.distanceBetween(
                secondLastLocation.latitude,
                secondLastLocation.longitude,
                loc.latitude, 
                loc.longitude);
              
              
              distanceTravelled += appendDist;
              int timeDuration = currentTime - lastTime;

              if (timeDuration != 0){
                pace = (timeDuration*60)/(appendDist*1000);
                
              }
            }
            
        }
        lastTime = currentTime;
        debugPrint('$pace');
        });
      }
   
    });
  }
}

