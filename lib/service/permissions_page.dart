import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionSettings extends StatefulWidget {
  const PermissionSettings({super.key});

  @override
  State<PermissionSettings> createState() => _PermissionSettingsState();
}

class _PermissionSettingsState extends State<PermissionSettings> {
  bool _isLocationGranted = false;
  bool _isNotificationGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // Check the current permissions for location and notification
  Future<void> _checkPermissions() async {
    final locationStatus = await Permission.location.status;
    final notificationStatus = await Permission.notification.status;

    setState(() {
      _isLocationGranted = locationStatus.isGranted;
      _isNotificationGranted = notificationStatus.isGranted;
    });
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        _isLocationGranted = true;
      });
    } else if (status.isDenied) {
      // Permission denied, show the request again
      setState(() {
        _isLocationGranted = false;
        _openLocationSettings();
      });
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, guide user to settings
      _openLocationSettings();
    }
  }

  // Request notification permission
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      setState(() {
        _isNotificationGranted = true;
      });
    } else if (status.isDenied) {
      // Permission denied, show the request again
      setState(() {
        _isNotificationGranted = false;
      });
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, guide user to settings
      _openNotificationSettings();
    }
  }


  Future<void> _openLocationSettings() async {
    openAppSettings();
  }

  Future<void> _openNotificationSettings() async {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Permission Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            ListTile(
              title: const Text("Location Permission"),
              subtitle: Text(_isLocationGranted
                  ? "Location access is granted"
                  : "Location access is denied"),
              trailing: IconButton(
                icon: Icon(
                    _isLocationGranted ? Icons.check : Icons.location_on),
                onPressed: _isLocationGranted
                    ? _openLocationSettings
                    : _requestLocationPermission,
              ),
            ),
            const Divider(),

            // Notification Permission
            ListTile(
              title: const Text("Notification Permission"),
              subtitle: Text(_isNotificationGranted
                  ? "Notifications are enabled"
                  : "Notifications are disabled"),
              trailing: IconButton(
                icon: Icon(
                    _isNotificationGranted ? Icons.notifications : Icons.notifications_off),
                onPressed: _isNotificationGranted
                    ? _openNotificationSettings
                    : _requestNotificationPermission,
              ),
            ),
            const Divider(),

            // Explanation text
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Note: If you have permanently denied a permission, you can open the app settings to enable it manually.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
