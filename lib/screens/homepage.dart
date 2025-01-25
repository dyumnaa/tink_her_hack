import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true, // Center the AppBar title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            Text(
              'Welcome to the Home Page!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Set the text color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Add spacing between widgets
            ElevatedButton(
              onPressed: () {
                // Add your button functionality here
                print('Button Pressed!');
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
