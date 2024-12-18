import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_root.dart';

class RegistrationModel {
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String org,
  }) async {
    const String uri = "$api_root/auth/users/";
    final Map<String, String> data = {
      'email': email.trim(),
      'password': password.trim(),
      'name': name.trim(),
      'org': org.trim(),
    };

    try {
      var response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      var jsonResponse = jsonDecode(response.body);
      return {'status': response.statusCode, 'data': jsonResponse};
    } catch (e) {
      print("Error during registration: $e");
      return {'status': 500, 'message': "An error occurred. Please try again."};
    }
  }
}
