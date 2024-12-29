import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final String? Function(String?)? validator;
  final bool readonlyVar;
  final String helper;
  final bool isNumeric;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
    this.validator,
    this.readonlyVar = false,
    this.helper = "",
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        obscureText: isPassword && !isPasswordVisible,
        decoration: InputDecoration(
          hintText: hintText,
          helperText: helper.isNotEmpty ? helper : null,
          helperStyle: TextStyle(color: Colors.yellow, letterSpacing: 2),
          fillColor: readonlyVar ? Colors.grey[200] : null,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onTogglePasswordVisibility,
          )
              : null,
        ),
        readOnly: readonlyVar,
        validator: validator,
      ),
    );
  }
}
