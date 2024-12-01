import 'package:flutter/material.dart';
import 'package:hire_me/view/registration_view.dart';
import 'package:provider/provider.dart';
import '../service/login_api_service.dart';
import '../service/profile_provider.dart';
import '../view/login_view.dart';

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
    if (_formKey.currentState!.validate()) {
      try {
        final tokens = await AuthService.login(
          _emailController.text,
          _passwordController.text,
        );
        final user = await AuthService.fetchUserProfile(tokens["accessToken"]!);

        // Store user profile and tokens
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.storeAccessToken(tokens["accessToken"]!);
        await profileProvider.saveProfileData({
          "name": user.name,
          "email": user.email,
        });

        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Homeview()));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed")),
        );
      }
    }
  }

  void _handleSignUp(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RegistrationView())); // Navigate to registration
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
