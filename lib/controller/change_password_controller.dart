import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/api/api_root.dart';
import 'package:http/http.dart' as http;

import '../model/change_password_model.dart';

class ChangePasswordController {
  Future<bool> changePassword(ChangePasswordModel model) async {
    final String apiUrl = "${api_root}/api/change-password";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Password changed successfully");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to change password: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e");
      return false;
    }
  }
}
