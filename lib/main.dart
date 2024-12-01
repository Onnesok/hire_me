import 'package:flutter/material.dart';
import 'package:hire_me/controller/login_controller.dart';
import 'package:hire_me/service/profile_provider.dart';
import 'package:hire_me/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // switch between light/dark based on system .....
        home: AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Check login status
    return profileProvider.isLoggedIn
        ? Home() // Navigate to home if logged in
        : LoginController(); // Navigate to login screen if not logged in
  }
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Home"),
    );
  }
}

