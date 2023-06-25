// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'loginpage.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/', // Set the initial route
    routes: {
      '/': (context) => LoginForm(), // Route for the login page
      // '/home': (context) => //Route for the home page
      // '/signup': (context) => // Route for the signup page
    },
  ));
}
