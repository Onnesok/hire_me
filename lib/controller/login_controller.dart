import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/widgets/bottom_appbar.dart';
import 'package:hire_me/view/registration_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_root.dart';
import '../service/profile_provider.dart';
import '../view/login_view.dart';
import 'package:http/http.dart' as http;

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill in all required fields");
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      const String uri = "${api_root}/login/";
      final body = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      Navigator.pop(context); // Close the loading indicator

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['message'] == "Login successful") {
          // Dynamically determine the key (user/admin/employee).......... AAAAAAAAAAAaaaaaaaaaaaaaaaaaaaaa
          final dynamic userData = jsonResponse['user'] ?? jsonResponse['admin'] ?? jsonResponse['employee'];

          if (userData == null) {
            Fluttertoast.showToast(msg: "No user data found.");
            return;
          }

          // Stored json as it was not saving...... worked
          final name = userData['username'] ?? 'Unknown';
          final email = userData['email'] ?? 'Unknown';
          final phoneNumber = userData['phone_number'] ?? 'Unknown';
          final avatar = userData['profile_picture'] ?? '';
          final address = userData['address'] ?? 'Unknown';
          final role = userData['role'] ?? 'Unknown';
          //final createdAt = userData['createdAt'] ?? '';
          //final updatedAt = userData['updatedAt'] ?? '';

          // Saving.....
          final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
          await profileProvider.saveProfileData(name, email, phoneNumber, avatar, address, role);

          // Saving login status jate gutaguti na kora lage prottekbar
          await LogInStatus();

          Fluttertoast.showToast(msg: "Login Successful!");
          Fluttertoast.showToast(msg: "Welcome $name!");

          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomBottomAppBar()),
          );
        } else {
          Fluttertoast.showToast(msg: jsonResponse['message'] ?? "Login failed.");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to login. Please try again.");
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
      debugPrint("Error: $e");
    }
  }


  //saving login status so that bar bar login niye guta guti na kora lage
  Future<void> LogInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }


  void _handleSignUp(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegistrationView()));
  }

  @override
  Widget build(BuildContext context) {
    return LoginView(
      formKey: _formKey,
      emailController: _emailController,
      passwordController: _passwordController,
      onLoginPressed: _handleLogin,
      onSignUpPressed: _handleSignUp,
    );
  }
}
