import 'package:diagnosify_app/core/services/sigletonesharedperference.dart';
import 'package:diagnosify_app/screens/HealthQuestionnaireScreen.dart';
import 'package:diagnosify_app/screens/Login_Screen.dart';
import 'package:diagnosify_app/screens/SignUp_Screen.dart';
import 'package:diagnosify_app/screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        // This makes the body fill the entire screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              // This makes the animated image take available space
              flex: 2, // Gives more weight to the image section
              child: Center(
                child: Animate(
                  effects: [
                    FadeEffect(duration: const Duration(seconds: 1)),
                    ScaleEffect(
                      begin: Offset(0, 0),
                      end: Offset(1, 1),
                      duration: const Duration(seconds: 1),
                    ),
                  ],
                  child: Image.asset(
                    'assets/IMG-20250226-WA0011-removebg-preview.png',
                    fit: BoxFit.contain, // Ensures image scales properly
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'Track your wellness, manage your health, and connect with care.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff048497),
                ),
              ),
            ),
            const Spacer(), // This pushes the button to the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  var token = SharedPreferenceSingleton.getString('token');
                  if (token == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Let\'s Start',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: const Color(0xff048497),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
