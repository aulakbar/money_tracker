import 'package:flutter/material.dart';
import '../localStorage/local_storage.dart';

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Clear user data from SharedPreferences
    clearUserData();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Logged out successfully!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login', // Replace '/login' with the route name for your login screen
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
