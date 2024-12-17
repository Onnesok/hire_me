import 'package:flutter/material.dart';
import 'package:hire_me/controller/map_page_controller.dart';
import 'package:hire_me/model/map_page_model.dart';
import 'package:hire_me/theme/app_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatelessWidget {
  final LocationModel locationModel;

  const MapView({required this.locationModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Location'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/ui/no_money.png", scale: 4),
            Text("Map Api test korte Dollar lage :("),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              child: AppTheme.gradientButton(
                text: "Donate money ? 🥺",
                onPressed: () => mapController.showDonationToast(),
              ),
            ),
            Text(" please ? 🥺", style: Theme.of(context).textTheme.headlineMedium),
            // Uncomment the following code to show the Google Map when the API key is available
            // GoogleMap(
            //   initialCameraPosition: CameraPosition(
            //     target: locationModel.currentLocation,
            //     zoom: 14.0,
            //   ),
            //   markers: {
            //     Marker(
            //       markerId: MarkerId('currentLocation'),
            //       position: locationModel.currentLocation,
            //       infoWindow: InfoWindow(title: 'You are here'),
            //     ),
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
