import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/rounded_button.dart';
import 'home_page.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.jpg'),
              ),
            ),
            SizedBox(height: 48.0),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) => email = value,
              decoration: InputDecoration(hintText: 'Enter your email'),
            ),
            SizedBox(height: 8.0),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) => password = value,
              decoration: InputDecoration(hintText: 'Enter your password'),
            ),
            SizedBox(height: 24.0),
            RoundedButton(
              color: Colors.blueAccent,
              title: 'Register',
              onPressed: () async {
                setState(() => showSpinner = true);
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if (newUser != null) {
                    Navigator.pushNamed(context, HomePage.id);
                  }
                } catch (e) {
                  print(e);
                } finally {
                  setState(() => showSpinner = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
