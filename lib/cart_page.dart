import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ServiceBooking {
  final String serviceName;
  final double servicePrice;
  final String customerName;
  final String employeeName;
  final String address;
  final DateTime scheduledDate;
  final String status;

  ServiceBooking({
    required this.serviceName,
    required this.servicePrice,
    required this.customerName,
    required this.employeeName,
    required this.address,
    required this.scheduledDate,
    required this.status,
  });

  // Factory method to parse JSON
  factory ServiceBooking.fromJson(Map<String, dynamic> json) {
    return ServiceBooking(
      serviceName: json['service']['name'],
      servicePrice: json['service']['price'].toDouble(),
      customerName: json['customer_details']['name'],
      employeeName: json['employee_details']['name'],
      address: json['address'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      status: json['status'],
    );
  }
}

// CartPage Tabs for tabbbbbb :v
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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          OrdersPage(
            scrollController: widget.scrollController,
            statusFilter: "pending",
            title: "Pending",
            statusColor: Colors.orange,
          ),
          // Tab 2: Completed Orders
          OrdersPage(
            scrollController: widget.scrollController,
            statusFilter: "completed",
            title: "Completed",
            statusColor: Colors.green,
          ),
          // Tab 3: Cancelled Orders
          OrdersPage(
            scrollController: widget.scrollController,
            statusFilter: "cancelled",
            title: "Cancelled",
            statusColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

// Generic Page for Displaying Orders Based on Status
class OrdersPage extends StatefulWidget {
  final ScrollController scrollController;
  final String statusFilter;
  final String title;
  final Color statusColor;

  const OrdersPage({
    super.key,
    required this.scrollController,
    required this.statusFilter,
    required this.title,
    required this.statusColor,
  });

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<ServiceBooking>> _serviceBookings;

  Future<List<ServiceBooking>> fetchServiceBookings() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final url = "${api_root}/service-bookings?customer_email=${profileProvider.email}&status=${widget.statusFilter}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => ServiceBooking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ${widget.title.toLowerCase()} orders');
    }
  }

  @override
  void initState() {
    super.initState();
    _serviceBookings = fetchServiceBookings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ServiceBooking>>(
      future: _serviceBookings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No ${widget.title.toLowerCase()} orders found.'));
        } else {
          final bookings = snapshot.data!;
          return ListView.builder(
            controller: widget.scrollController,
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    '${booking.serviceName} - \$${booking.servicePrice}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Customer: ${booking.customerName}\n'
                        'Employee: ${booking.employeeName}\n'
                        'Address: ${booking.address}\n'
                        'Date: ${booking.scheduledDate.toLocal()}',
                  ),
                  trailing: Text(
                    widget.title.toUpperCase(),
                    style: TextStyle(color: widget.statusColor),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

