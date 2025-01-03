import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final String apiUrl = "${api_root}/users";
  final String blockCustomerApiUrl = "${api_root}/block"; // Block API

  bool isLoading = true;
  List<dynamic> customers = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          customers = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Block customer function
  Future<void> blockCustomer(String customerId) async {
    try {
      // Find the customer using the customerId
      final customer = customers.firstWhere((cu) => cu['_id'] == customerId);
      final email = customer['email'];

      final response = await http.post(
        Uri.parse(blockCustomerApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,  // Send email instead of customerId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove customer from the list after blocking
        setState(() {
          customers.removeWhere((customer) => customer['_id'] == customerId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer blocked successfully')),
        );
      } else {
        throw Exception('Failed to block customer');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Management"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : customers.isEmpty
                ? const Center(child: Text("No customers found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                    ),
                    title: Text(customer['username'], style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${customer['email']}"),
                        Text("Phone: ${customer['phone_number']}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.block, color: Colors.orange),
                      onPressed: () => blockCustomer(customer['_id']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
