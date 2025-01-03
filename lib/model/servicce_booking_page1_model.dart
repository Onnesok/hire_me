import 'package:hire_me/api/api_root.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ServiceBookingModel1 {
  Future<List<dynamic>> fetchProviders(String service, DateTime selectedDate) async {
    List<dynamic> availableProviders = [];
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String apiUrl = "${api_root}/employees/work/free?date=${formattedDate}&role=${service}";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        availableProviders = json.decode(response.body);
      }
    } catch (error) {
      throw Exception('Failed to fetch providers');
    }
    return availableProviders;
  }
}
