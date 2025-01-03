import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingModel {
  // Handles the service booking process
  Future<bool> bookService({
    required String customerEmail,
    required String employeeEmail,
    required String serviceName,
    required double price,
    required String selectedDate,
    required String description,
    required String apiRoot,
  }) async {
    final bookingData = {
      "customer_email": customerEmail,
      "employee_email": employeeEmail,
      "service": {
        "name": serviceName,
        "price": price,
      },
      "scheduled_date": selectedDate,
      "description": description,
    };

    final url = "$apiRoot/service-bookings";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("Error during booking: $error");
      return false;
    }
  }
}
