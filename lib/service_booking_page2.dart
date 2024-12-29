import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:hire_me/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ServiceBookingDetails extends StatefulWidget {
  final String selectedDate;
  final Map<String, dynamic> employeeDetails;
  final String serviceName;

  const ServiceBookingDetails({
    required this.selectedDate,
    required this.employeeDetails,
    required this.serviceName,
    Key? key,
  }) : super(key: key);

  @override
  _ServiceBookingDetailsState createState() => _ServiceBookingDetailsState();
}

class _ServiceBookingDetailsState extends State<ServiceBookingDetails> {
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _bookService() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final bookingData = {
      "customer_email": profileProvider.email,
      "employee_email": widget.employeeDetails['email'],
      "service": {
        "name": widget.serviceName,
        "price": widget.employeeDetails['price'] ?? 50,
      },
      "scheduled_date": widget.selectedDate,
      "description": _descriptionController.text,
    };

    final url = "${api_root}/service-bookings";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking successful!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book service. Try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = widget.employeeDetails['price'] ?? 50;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Provider',
                      widget.employeeDetails['username'] ?? 'N/A',
                      theme.textTheme,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Scheduled Date',
                      widget.selectedDate,
                      theme.textTheme,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Price',
                      '\$$price',
                      theme.textTheme,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description Section
            Text(
              'Description',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Add specific requirements or details',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: theme.scaffoldBackgroundColor,
        child: AppTheme.gradientButton(
          text: "Sign In",
          onPressed: () => _bookService(),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
