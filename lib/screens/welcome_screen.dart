import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import 'registration_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

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
            _buildLogoAndTitle(),
            SizedBox(height: 48.0),
            _buildLoginButton(context),
            _buildRegisterButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoAndTitle() {
    return Row(
      children: <Widget>[
        Hero(
          tag: 'logo',
          child: Container(
            height: 60.0,
            child: Image.asset('images/logo.jpg'),
          ),
        ),
        Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 45.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return RoundedButton(
      color: Colors.lightBlueAccent,
      title: 'Log In',
      onPressed: () {
        Navigator.pushNamed(context, LoginScreen.id);
      },
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return RoundedButton(
      color: Colors.blueAccent,
      title: 'Register',
      onPressed: () {
        Navigator.pushNamed(context, RegistrationScreen.id);
      },
    );
  }
}
