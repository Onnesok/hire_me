import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hire_me/controller/change_password_controller.dart';
import 'package:hire_me/model/change_password_model.dart';
import 'package:hire_me/widgets/custom_input_field.dart';
import 'package:hire_me/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../service/profile_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late ChangePasswordController _controller;

  // Individual password visibility flags
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = ChangePasswordController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  // Password strength validator
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must include at least one special character";
    }
    return null;
  }

  Future<void> _changePassword() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    if (_newPasswordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(msg: "Passwords do not match");
      return;
    }

    final changePasswordModel = ChangePasswordModel(
      email: profileProvider.email,
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    final success = await _controller.changePassword(changePasswordModel);
    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ui/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                Center(
                  child: Image.asset(
                    'assets/Icon/hireme.png',
                    height: 100,
                    width: 100,
                  ),
                ),

                const SizedBox(height: 20),

                Divider(),

                const SizedBox(height: 20),

                CustomInputField(
                  controller: _oldPasswordController,
                  hintText: "Enter your old password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isPasswordVisible: _isOldPasswordVisible,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your old password";
                    }
                    return null;
                  },
                ),

                CustomInputField(
                  controller: _newPasswordController,
                  hintText: "Enter your new password",
                  icon: Icons.lock_person_outlined,
                  isPassword: true,
                  isPasswordVisible: _isNewPasswordVisible,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                  validator: _passwordValidator,
                ),

                CustomInputField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm your new password",
                  icon: Icons.lock_person_outlined,
                  isPassword: true,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your new password";
                    }
                    if (value != _newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AppTheme.gradientButton(
                  text: "Change Password",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    } else {
                      Fluttertoast.showToast(msg: "Please fill in all fields correctly");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
