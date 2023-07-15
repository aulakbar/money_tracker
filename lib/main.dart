// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'loginpage.dart';
import './home/tab_controller_feature.dart';
import './home/logout.dart';
import './localStorage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var logedin = await getValueBool('is_logedin');
  print('telah login : $logedin');
  runApp(MaterialApp(
    // initialRoute: '/', // Set the initial route
    home: logedin ? HomeView() : LoginForm(),
    routes: {
      '/login': (context) => LoginForm(), // Route for the login page
      '/home': (context) => HomeView(), //Route for the home page
      '/logout': (contet) => LogoutScreen(),
      // '/signup': (context) => // Route for the signup page
    },
  ));
}
