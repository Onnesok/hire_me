import 'package:flutter/material.dart';

class AppTheme {

  ////////// Light Theme for you know who  :) //////////
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 4,
      titleTextStyle:
          TextStyle(color: Colors.black, fontSize: 20),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Body text color for readability
      bodyMedium: TextStyle(color: Colors.black87), // Slightly lighter body text
      titleLarge: TextStyle(color: Colors.black), // Headline text color
      labelLarge: TextStyle(color: Colors.white), // Button text color
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),

    iconTheme: const IconThemeData(color: Colors.black),

    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.all(8),
    ),


    dividerTheme: DividerThemeData(
      color: Colors.grey[400]!,
      thickness: 1,
      space: 10,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.black),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      prefixIconColor: Colors.black,
      suffixIconColor: Colors.black,
    ),
  );


  ////////// Dark Theme for awesome people  :) //////////
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: const Color(0xFF171717),
    //scaffoldBackgroundColor: Colors.black87,

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF171717),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),

    textTheme: TextTheme(
      bodyLarge: const TextStyle(color: Colors.white), // Body text color for general readability
      bodyMedium: TextStyle(color: Colors.grey[300]), // Lighter grey for less emphasis text
      titleLarge: const TextStyle(color: Colors.white), // Headline text color
      labelLarge: const TextStyle(color: Colors.white), // Button text color
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),


    iconTheme: const IconThemeData(color: Colors.white),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white60,
      backgroundColor: Colors.grey[900],
      elevation: 8,
    ),


    cardTheme: CardTheme(
      color: Colors.grey[800],
      elevation: 4,
      margin: const EdgeInsets.all(8),
    ),

    dividerTheme: DividerThemeData(
      color: Colors.grey[600],
      thickness: 1,
      space: 10,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey.shade600),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      prefixIconColor: Colors.blue,
      suffixIconColor: Colors.blue,
    ),
  );


  //////////........ Reusable gradient button....... //////////
  static Widget gradientButton( {
    required String text,
    required VoidCallback onPressed,
    double height = 50,
    double borderRadius = 25,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }


  //////////........ gradientTextStyle....... //////////
  static TextStyle gradientTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required List<Color> gradientColors,
    Rect shaderBounds = const Rect.fromLTWH(0, 0, 200, 70),
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: gradientColors,
        ).createShader(shaderBounds),
    );
  }
}















