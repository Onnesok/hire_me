import 'package:flutter/material.dart';
import 'package:hire_me/search_page.dart'; // imorting searchPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartPage(scrollController: ScrollController()), // passing scrollController here
    );
  }
}

class CartPage extends StatefulWidget {
  final ScrollController scrollController;
  const CartPage({super.key, required this.scrollController});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Ongoing"),
            Tab(text: "History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Ongoing Page
          CartOngoingPage(),
          // History Page
          CartHistoryPage(),
        ],
      ),
    );
  }
}

// reusable page widget
class ViewAllServicesButton extends StatelessWidget {
  const ViewAllServicesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the SearchPage inside Home (using the custom route and animation)
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200), // Slower animation duration
            pageBuilder: (context, animation, secondaryAnimation) {
              return SearchPage(); // Navigate to the SearchPage
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,  // Background color of the button
        foregroundColor: Colors.white,  // Text color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),  // Rounded corners
        ),
      ),
      child: const Text("View all services"),
    );
  }
}

class CartOngoingPage extends StatelessWidget {
  const CartOngoingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Let us help you!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Place your order",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const ViewAllServicesButton(),  // Reusable button
        const SizedBox(height: 16),
      ],
    );
  }
}

class CartHistoryPage extends StatelessWidget {
  const CartHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "No history between us!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Let’s begin our journey together!",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        const ViewAllServicesButton(),  // Reusable button
      ],
    );
  }
}
