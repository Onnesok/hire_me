import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_root.dart';

class RegistrationModel {
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    const String uri = "$api_root/register";
    final Map<String, String> data = {
      'username': name.trim(),
      'email': email.trim(),
      'password': password.trim(),
      "phone_number": "123-456-7890",
      "profile_picture": "https://imgcdn.stablediffusionweb.com/2024/9/7/f5a37602-08b8-43f7-b5ae-9f39e90308fb.jpg",
      "address": "Gulsan2",
      'role': "user",
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
