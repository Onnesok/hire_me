import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/search_page.dart';
import 'package:hire_me/service/local_notification.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:hire_me/service/themeprovider.dart';
import 'package:hire_me/view/banner_list_view.dart';
import 'package:hire_me/view/service_booking_page1_view.dart';
import 'package:hire_me/widgets/appbar_home_widget.dart';
import 'package:hire_me/widgets/custom_bottom_sheet.dart';
import 'package:hire_me/widgets/home_ItemGridView_widget.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

// TODO: Tobe completed... Its not done yet and not mvc in the least

class Home extends StatefulWidget {
  final ScrollController controller;

  const Home({required this.controller, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> itemList = [
    'Plumber',
    'Electrician',
    'Cleaner',
    'Painter',
    'Gardener',
    'Carpenter',
    'Maid Service',
    'Pest Control',
    'Ac Repair',
    'More Services'
  ];

  final Map<String, IconData> serviceIcons = {
    'Plumber': HugeIcons.strokeRoundedWaterPump,
    'Electrician': HugeIcons.strokeRoundedElectricHome01,
    'Cleaner': HugeIcons.strokeRoundedCleaningBucket,
    'Painter': HugeIcons.strokeRoundedPaintBrush02,
    'Gardener': HugeIcons.strokeRoundedPlant02,
    'Carpenter': HugeIcons.strokeRoundedArtboardTool,
    'Maid Service': HugeIcons.strokeRoundedService,
    'Pest Control': HugeIcons.strokeRoundedBug01,
    'Ac Repair': Icons.ac_unit_outlined,
    'More Services': HugeIcons.strokeRoundedDashboardCircleAdd,
  };

  // Map of colors for icons
  final Map<String, Color> serviceColors = const {
    'Plumber': Colors.blueAccent,
    'Electrician': Colors.orangeAccent,
    'Cleaner': Colors.greenAccent,
    'Painter': Colors.purpleAccent,
    'Gardener': Colors.teal,
    'Carpenter': Colors.brown,
    'Maid Service': Colors.pinkAccent,
    'Pest Control': Colors.redAccent,
    'Ac Repair': Colors.cyan,
    'More Services':Colors.deepOrange,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: appBar(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ui/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          controller: widget.controller,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
          // Search bar
          _buildSearchBar(context),
          // Banner ListView
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BannerListView(
                  callBack: () {
                    // Additional actions can be added here.... :)
                  },
                ),
              ),
              // Item GridView
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Our Services',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16,),
                    ItemGridView(
                      items: filteredItems,
                      onItemTap: (item) {
                        if (item == 'More Services') {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return CustomBottomSheet(
                                title: 'More Services',
                                children: [
                                  ListTile(
                                    title: Text('Service 1'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text('Service 2'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceBookingView(service: item,),
                            ),
                          );
                        }
                      },
                      serviceIcons: serviceIcons,
                      serviceColors: serviceColors,
                    ),

                  ],
                ),
              ),

              // Featured Service Providers
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Services',
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
      ),
    );
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

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
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
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.white.withOpacity(0.7),
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.blueAccent.withOpacity(0.3)
                      : Colors.blueAccent.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.4)
                    : Colors.black.withOpacity(0.2),
                width: 0.2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  // Content layer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Service text
                        Expanded(
                          child: Text(
                            'Search services...',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Search icon on the right
                        Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
