import 'package:flutter/material.dart';
import 'screens/homepage.dart'; // Import the HomePage file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'Basic App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define the primary app color
      ),
      home: HomePage(), // Set HomePage as the default route
      routes: {
        '/home': (context) => HomePage(), // Define additional routes if needed
      },
    );
  }
}
run