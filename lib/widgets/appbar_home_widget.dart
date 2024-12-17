import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hire_me/view/notification_page_view.dart';
import '../model/map_page_model.dart';
import '../view/map_page_view.dart';

Widget appBar(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return SafeArea(
    top: true,
    child: PreferredSize(
      preferredSize: Size.fromHeight(120),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            color: theme.appBarTheme.backgroundColor,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  Position? position = await _getCurrentLocationPosition();
                  if (position != null) {
                    final currentLocation = LatLng(position.latitude, position.longitude);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          LocationModel locationModel = LocationModel(currentLocation: currentLocation);
                          return MapView(locationModel: locationModel);
                        },
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'Failed to get location');
                  }
                },
                icon: Icon(Icons.location_on, color: theme.iconTheme.color),
              ),
              Expanded(
                child: FutureBuilder<String>(
                  future: _getCurrentLocation(),
                  builder: (context, snapshot) {
                    return Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        snapshot.data ?? 'Locating you...',
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => NotificationViewPage()));
                },
                icon: Icon(Icons.notifications_none_outlined, color: theme.iconTheme.color),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}



Future<Position?> _getCurrentLocationPosition() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permission denied');
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error getting location: $e');
    return null;
  }
}



Future<String> _getCurrentLocation() async {
  Position? position = await _getCurrentLocationPosition();

  if (position == null) {
    return 'Location not available';
  }

  try {
    // Get detailed placemark information
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      // Construct a detailed location string
      String line1 = '';
      String line2 = '';

      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        line1 += place.subLocality!;
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        if (line1.isNotEmpty) {
          line1 += ', ';
        }
        line1 += place.locality!;
      }

      if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
        line2 += place.administrativeArea!;
      }
      if (place.country != null && place.country!.isNotEmpty) {
        if (line2.isNotEmpty) {
          line2 += ', ';
        }
        line2 += place.country!;
      }

      return '$line1\n$line2';
    }

    return 'Address not found';
  } catch (e) {
    return 'Error fetching location: ${e.toString()}';
  }
}