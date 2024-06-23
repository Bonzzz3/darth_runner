import 'dart:async';
import 'package:darth_runner/map/map%20widgets/playbar.dart';
import 'package:darth_runner/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locationController = Location();
  static const LatLng _towngreen = LatLng(1.3051320676351397, 103.77317545254137);
  LatLng? currentPosition;
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  // to store the positions and list the locations and draw the polyline
  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> polyLine = {};

  final Stopwatch stopWatch = Stopwatch();
  bool isRunning = false;
  double distanceTravelled = 0.0;

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
          onMapCreated: ((GoogleMapController controller) => 
          mapController.complete(controller)),

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
              boxShadow:const [ 
                BoxShadow(
                color: Color.fromRGBO(17, 3, 40, 1),
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(5, 5) 
                ) ,
              ],
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              ),
            child: const Column(
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
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
                        //Text('paceValue'),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Text('Time',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Text('Distance',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Divider(),
                SizedBox(
                  height: 70,
                ),
                // add the play button widget.
                Playbar()
                // IconButton(
                //   onPressed :() {
                //     Navigator.push(
                //       context, MaterialPageRoute(
                //         builder: (context) => const NotHomePage()
                //         )
                //       );
                //   },
                //    icon: const Icon(
                //     Icons.stop_circle_outlined,
                //     size: 50,
                //     color: Colors.redAccent,
                //     )
                //    )
              ],
            )
            )
          )
        ]
      ), 
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

  
  // function to obtain the current location, 
  // set the location variables lat and lng,
  // and request permission if needed.
  // polyline generation is in the same function since requires the new location.
  Future<void> fetchLocation() async{
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

    locationController.onLocationChanged.listen((LocationData currentLocation) {
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        currentPosition = 
          LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!);
        polyLineCoordinates.add(currentPosition!);
        polyLine.add(
          Polyline(
            polylineId: const PolylineId('beenHere'),
            points: polyLineCoordinates,

            // display properties of the polyline.
            width: 5, //this width is a bit too small but need to check with update on zoom.
            color: Colors.deepPurpleAccent, // can make this a customizable feature.
          ) 
        );
        cameraToPosition(currentPosition!); 
          });
        }
      }
    );
  }
}