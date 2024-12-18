import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_input_field.dart';

class LoginView extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function onLoginPressed;
  final Function onSignUpPressed;

  const LoginView({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onSignUpPressed,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Center(
                  child: Image.asset(
                    'assets/Icon/hireme.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Welcome Back !",
                  textAlign: TextAlign.center,
                  style: AppTheme.gradientTextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    gradientColors: [Colors.blue, Colors.purple],
                  ),
                ),
                const SizedBox(height: 30),

                CustomInputField(
                  controller: widget.emailController,
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
                  controller: widget.passwordController,
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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Not applicable right now");
                    },
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Login Button :3
                AppTheme.gradientButton(
                  text: "Sign In",
                  onPressed: () => widget.onLoginPressed(),
                ),

                const SizedBox(height: 20),

                // Registration navigation :v
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () => widget.onSignUpPressed(context),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

}
