import 'package:flutter/material.dart';
import 'package:hire_me/theme/app_theme.dart';
import '../controller/service_booking_page2_controller.dart';
import '../model/service_booking_page2_model.dart';

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
  late ServiceBookingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceBookingController(model: BookingModel());
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
              style: TextStyle(color: Colors.black87),
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
          text: "Confirm Booking",
          onPressed: () => _controller.bookService(
            context,
            widget.selectedDate,
            widget.employeeDetails,
            widget.serviceName,
            _descriptionController,
          ),
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
            color: Colors.blueAccent,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
