import 'package:flutter/material.dart';
import 'screens/homepage.dart'; // Import the HomePage file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hide the debug banner
      title: 'Basic App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto', // Set a global font
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo, // Consistent AppBar color
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
