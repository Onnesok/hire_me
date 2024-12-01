import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../api/api_root.dart';
import '../model/login_model.dart';

class AuthService {
  static Future<Map<String, String>> login(String email, String password) async {
    final url = Uri.parse("$api_root/auth/jwt/create/");
    final body = jsonEncode({"email": email, "password": password});
    final headers = {"Content-Type": "application/json"};

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return {
        "accessToken": jsonResponse['access'],
        "refreshToken": jsonResponse['refresh'],
      };
    } else {
      Fluttertoast.showToast(msg: "Failed to login..");
      throw Exception("Failed to login: ${response.body}");
    }
  }

  static Future<User> fetchUserProfile(String accessToken) async {
    const String apiEndpoint = '$api_root/update-profile/';
    final response = await http.get(
      Uri.parse(apiEndpoint),
      headers: {'Authorization': 'JWT $accessToken'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch profile: ${response.statusCode}");
    }
  }
}
