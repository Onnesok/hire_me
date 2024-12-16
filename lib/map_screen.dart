
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final LatLng currentLocation;

  const MapScreen({required this.currentLocation, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Location')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 100, color: Colors.teal,),
            Text("Map Api test korte 200 Dollar lage :("),
          ],
        ),
      ),
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     target: currentLocation,
      //     zoom: 14.0,
      //   ),
      //   markers: {
      //     Marker(
      //       markerId: MarkerId('currentLocation'),
      //       position: currentLocation,
      //       infoWindow: InfoWindow(title: 'You are here'),
      //     ),
      //   },
      // ),
    );
  }
}