import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/controller/login_controller.dart';
import 'package:provider/provider.dart';

import '../controller/registration_controller.dart';
import '../service/profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_input_field.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final RegistrationController _controller = RegistrationController();

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      _controller.registerUser(
        name: _NameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: "user",
        onSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginController()),
          );
        },
        onError: (message) {
          Fluttertoast.showToast(msg: message);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/Icon/hireme.png',
                  height: 100,
                  width: 100,
                ),

                const SizedBox(height: 2),

                Text(
                  "Please Create Your Account",
                  textAlign: TextAlign.center,
                  style: AppTheme.gradientTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    gradientColors: [Colors.blue, Colors.purple],
                  ),
                ),

                const SizedBox(height: 6),
                Column(
                  children: [

                    CustomInputField(
                        controller: _NameController,
                        hintText: "Full Name",
                        icon: Icons.drive_file_rename_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Full Name';
                        } else if (RegExp(r'\d').hasMatch(value)) {
                          return "Please enter a valid name";
                        }
                        return null;
                      },
                    ),


                    CustomInputField(
                        controller: _emailController,
                        hintText: "Enter your email",
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        }
                    ),

                    CustomInputField(
                      controller: _passwordController,
                      hintText: "Enter your password",
                      isPassword: true,
                      icon: Icons.lock_outline,
                      isPasswordVisible: _isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters long";
                        } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return "Password must include at least one uppercase letter";
                        } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return "Password must include at least one lowercase letter";
                        } else if (!RegExp(r'\d').hasMatch(value)) {
                          return "Password must include at least one number";
                        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return "Password must include at least one special character";
                        }
                        return null;
                      },
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),

                    CustomInputField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm password",
                      isPassword: true,
                      icon: Icons.lock_outline,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        } else if (_passwordController.text != value) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      onTogglePasswordVisibility: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),

                    const SizedBox(height: 30),
                    // Register button
                    AppTheme.gradientButton(
                      text: "Register account",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerUser();
                        }
                      }
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ?",
                            style: theme.textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginController()),
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
