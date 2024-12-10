import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hire_me/notification_page.dart';
import 'package:hire_me/search_page.dart';
import 'package:hire_me/service/local_notification.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:hire_me/service/themeprovider.dart';
import 'package:hire_me/view/banner_list_view.dart';
import 'package:provider/provider.dart';
import 'controller/login_controller.dart';

class Home extends StatefulWidget {
  final ScrollController controller;

  const Home({required this.controller, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> itemList = [
    'Plumbing',
    'Electrician',
    'Cleaning',
    'Painting',
    'Gardening',
    'Carpentry',
    'Maid Service',
    'Pest Control',
    'AC Repair',
  ];

  final Map<String, IconData> serviceIcons = {
    'Plumbing': Icons.water_damage,
    'Electrician': Icons.electrical_services,
    'Cleaning': Icons.cleaning_services,
    'Painting': Icons.brush,
    'Gardening': Icons.grass,
    'Carpentry': Icons.handyman,
    'Maid Service': Icons.woman,
    'Pest Control': Icons.pest_control,
    'AC Repair': Icons.ac_unit,
  };

  List<String> filteredItems = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = itemList; // Initially showing all items
    searchController.addListener(_filterItems);
  }

  void _filterItems() {
    setState(() {
      filteredItems = itemList
          .where((item) => item.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterItems);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final shadowColor = themeProvider.isDarkMode ? Colors.black87 : Colors.grey[300]!;
    final highlightColor = themeProvider.isDarkMode ? Colors.grey[800]! : Colors.white;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: appBar(context),
      ),
      body: SingleChildScrollView(
        controller: widget.controller,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the Search Page with custom route and animation duration
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 200), // Slower animation duration
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SearchPage(); // Your target page
                      },
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0); // Start from the bottom
                        const end = Offset.zero; // End at the final position
                        const curve = Curves.easeInOut; // Smooth curve for transition

                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(position: offsetAnimation, child: child);
                      },
                    ),
                  );
                },
                child: Hero(
                  tag: 'searchBar', // Unique tag which I will change later
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            //color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05), // Soft shadow
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1, // Spread the shadow for floating effect
                            offset: Offset(0, 0), // Offset to create a lifted effect (pore dekhtesi jeta valo hoy)
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Theme.of(context).iconTheme.color,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Search services...',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),




            // Banner ListView
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BannerListView(
                callBack: () {
                  // Additional actions can be added here
                },
              ),
            ),
            // Item GridView
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: ItemGridView(
                items: filteredItems,
                onItemTap: (item) {
                  LocalNotificationService.showNotification(
                    id: 1,
                    title: "Service Request",
                    body: "You tapped on $item.",
                  );
                  Fluttertoast.showToast(msg: "Tapped on $item");
                },
                serviceIcons: serviceIcons, // Pass the icons map
              ),
            ),
            // Featured Service Providers
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Service Providers',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  // Placeholder for service providers (can be a list or cards)
                  // Here, you can add dynamic content for featured providers ... yo
                  Container(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _serviceProviderCard('John Doe', 'Plumbing', Icons.water_damage),
                        _serviceProviderCard('Jane Smith', 'Electrician', Icons.electrical_services),
                        _serviceProviderCard('Alex Brown', 'Cleaning', Icons.cleaning_services),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Recent Requests
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Service Requests',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  // Placeholder for recent service requests
                  // Here, you can show a list of recent requests made by users........ :D
                  Container(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _recentRequestCard('Plumbing', 'John Doe', 'Just now'),
                        _recentRequestCard('Cleaning', 'Jane Smith', '5 minutes ago'),
                        _recentRequestCard('Electrician', 'Alex Brown', '10 minutes ago'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Promotions/Discounts
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Promotions & Discounts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  // Placeholder for promotions (can be dynamic content)
                  // Here, you can add a list of ongoing discounts or promotions....
                  Container(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _promotionCard('20% off on Plumbing Services', 'Use code PLUMB20'),
                        _promotionCard('15% off on Cleaning Services', 'Use code CLEAN15'),
                        _promotionCard('10% off on Electrician Services', 'Use code ELECTRIC10'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                          builder: (context) => MapScreen(currentLocation: currentLocation),
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
                      return Padding(
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
                        context, MaterialPageRoute(builder: (context) => NotificationListPage()));
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





  Widget _serviceProviderCard(String name, String service, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 150,
        child: Column(
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 8),
            Text(name),
            Text(service),
          ],
        ),
      ),
    );
  }

  Widget _recentRequestCard(String service, String name, String time) {
    return Card(
      margin: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 200,
        child: Column(
          children: [
            Text(service),
            Text(name),
            Text(time),
          ],
        ),
      ),
    );
  }

  Widget _promotionCard(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 250,
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}






class ItemGridView extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTap;
  final Map<String, IconData> serviceIcons;

  const ItemGridView({
    required this.items,
    required this.onItemTap,
    required this.serviceIcons,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onItemTap(item),
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(serviceIcons[item], size: 40),
                SizedBox(height: 8),
                Text(item),
              ],
            ),
          ),
        );
      },
    );
  }
}




















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
