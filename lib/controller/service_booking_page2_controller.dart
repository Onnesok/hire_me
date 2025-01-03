import 'package:flutter/material.dart';
import 'package:hire_me/api/api_root.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:provider/provider.dart';

import '../model/service_booking_page2_model.dart';

class ServiceBookingController {
  final BookingModel model;

  ServiceBookingController({required this.model});

  Future<void> bookService(
      BuildContext context,
      String selectedDate,
      Map<String, dynamic> employeeDetails,
      String serviceName,
      TextEditingController descriptionController,
      ) async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final bookingSuccess = await model.bookService(
      customerEmail: profileProvider.email,
      employeeEmail: employeeDetails['email'],
      serviceName: serviceName,
      price: employeeDetails['price'] ?? 50,
      selectedDate: selectedDate,
      description: descriptionController.text,
      apiRoot: api_root,
    );

    if (bookingSuccess) {
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
  }
}
