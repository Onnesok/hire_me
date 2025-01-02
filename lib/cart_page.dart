import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ServiceBooking {
  final String id;
  final String serviceName;
  final double servicePrice;
  final String customerName;
  final String employeeName;
  final String address;
  final DateTime scheduledDate;
  final String status;

  ServiceBooking({
    required this.id,
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
      id: json['_id'], // Add the 'id' to the model
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

// CartPage Tabs for tab
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
    _tabController = TabController(length: 2, vsync: this);  // Now only two tabs: Pending and Completed
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

  // Function to show confirmation dialog for cancellation
  Future<void> _showCancelDialog(ServiceBooking booking) async {
    bool cancelConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // The dialog won't dismiss if tapped outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order?'),
          content: Text('Are you sure you want to cancel and delete the order for "${booking.serviceName}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, do not cancel
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, cancel
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ) ?? false;

    if (cancelConfirmed) {
      // Send DELETE request to delete the booking
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final url = "${api_root}/service-bookings/${booking.id}"; // DELETE request URL

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order for "${booking.serviceName}" has been cancelled.')),
        );
        // Refresh the bookings list by re-fetching
        setState(() {
          _serviceBookings = fetchServiceBookings();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete the order.')),
        );
      }
    }
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title.toUpperCase(),
                        style: TextStyle(color: widget.statusColor),
                      ),
                      if (widget.statusFilter == 'pending') // Only show the cancel button for pending orders
                        IconButton(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            _showCancelDialog(booking); // Show confirmation dialog
                          },
                        ),
                    ],
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

