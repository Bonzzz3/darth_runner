import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:darth_runner/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:math';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locationController = Location();
  static const LatLng _towngreen = LatLng(1.3051320676351397, 103.77317545254137);
  LatLng? currentPosition;

  // to store the positions and list the locations and draw the polyline
  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLine = {};

  final Stopwatch stopWatch = Stopwatch();
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();
  bool isRunning = false;
  double distanceTravelled = 0.0;
  double appendDist = 0.0;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.
    addPostFrameCallback((_) async => await fetchLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
      :Stack(
        children: [
          GoogleMap(
          onMapCreated: (GoogleMapController controller) => mapController.complete(controller),

          //setting the initial position when the map is loaded.
          initialCameraPosition: const CameraPosition(
            target: _towngreen, // change the target to show the user's current position.
            zoom: 16, 
          ),
          markers: {
            Marker(
              markerId: const MarkerId('currentLocation'),
              icon: BitmapDescriptor.defaultMarker, // edit the icon of the current position
              position: currentPosition!
              )
          },
          polylines: polyLine,
        ),
  
        // Container to print the current stats:
        // Change the decoration.
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
                  const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(9),
                        child: Text('Pace',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                      ),
                      // Text('paceValue')
                    ],
                  ),
                  const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(9),
                        child: Text('Time',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                      ),
                      // Text('Time stamp')
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(9),
                        child: Text('Distance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          ),
                        ), 
                      ),
                      Text((distanceTravelled / 1000).toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )
                      )
                    ],
                  ),
                ],
              ),
              const Divider(), //add parameters
              const SizedBox(
                height: 70,
              ),
              Row(
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
                  )
                ],
              ),
            )
          )
        ],
      )
    );  
  }


  // function that repositions the map to center the user's
  // current location.
  Future<void> cameraToPosition (LatLng pos) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPosition = CameraPosition(
      target: pos,
      zoom: 16, //might need to optimize the zoom value
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

          // ADD POLYLINE TO SET.
          polyLine.add(
            Polyline(
              polylineId: const PolylineId('beenHere'),
              points: polyLineCoordinates,
              width: 5, //this width is a bit too small but need to check with update on zoom.
              color: Colors.deepPurpleAccent, // can make this a customizable feature.
            ) 
          );

          // CENTERING THE CAMERA ON LOCATION CHANGE.
          cameraToPosition(currentPosition!); 

          // FUNCTION TO CONVERT DEGREES TO RADIAN.
          double degToRadians (double degrees) {
            return degrees * pi / 180;
          }

          // FUNCTION TO GET DISTANCE FROM LAT AND LONG USING HAVERSINE FORMULA.
          double distanceBetween (double lat1,lon1,lat2,lon2){
            const R = 6371e3; // EARTH RADIUS IN METERS
            var dLat = degToRadians(lat2 - lat1);
            var dLon = degToRadians(lon2 - lon1);
            var a = sin(dLat / 2) * sin(dLat / 2) +
                cos(degToRadians(lat1)) * cos(degToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
            var c = 2 * asin(sqrt(a));
            return R * c;
          }

          // FUNCTION TO CALCULATE THE DISTANCE TRAVELLED WHILE PLAY BUTTON ACTIVE.
          if (isRunning) {
            if (polyLineCoordinates.length >= 2)  {
              LatLng secondLastLocation = polyLineCoordinates[polyLineCoordinates.length-2];
              appendDist =  Geolocator.distanceBetween(
                secondLastLocation.latitude,
                secondLastLocation.longitude,
                loc.latitude, 
                loc.longitude);
              // appendDist = distanceBetween(
              //   polyLineCoordinates.last.latitude,
              //   polyLineCoordinates.last.longitude,
              //   loc.latitude, 
              //   loc.longitude
              // );
              debugPrint('${polyLineCoordinates.last}');
              debugPrint('$loc');
              debugPrint('distance between old and new position is : $appendDist in meters i guess');
              distanceTravelled += appendDist;
              debugPrint('total distance travelled is $distanceTravelled in meters i guess');
            }
            else{
              distanceTravelled = 0.0;
            }
          }
        });
      }
   
    });
  }
}