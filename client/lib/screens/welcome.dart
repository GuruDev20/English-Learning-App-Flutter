import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = "WelcomeScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 29,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 26, 107, 68),
              ),
            ),
            Text(
              'Enhance your skills through this app',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Quicksand',
                color: Color.fromARGB(255, 150, 147, 147),
              ),
            ),
            Image.asset('assets/wel10.jpg'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: const Text('Get Started'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF042D29),
                textStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  color: Colors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(150, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}