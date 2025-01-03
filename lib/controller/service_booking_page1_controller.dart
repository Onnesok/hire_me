import 'package:flutter/material.dart';
import '../model/servicce_booking_page1_model.dart';

class ServiceBookingController1 {
  final ServiceBookingModel1 model;

  ServiceBookingController1(this.model);

  Future<List<dynamic>> fetchProviders(BuildContext context, String service, DateTime selectedDate) async {
    try {
      return await model.fetchProviders(service, selectedDate);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while fetching providers.')),
      );
      return [];
    }
  }
}
