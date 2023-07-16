// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'home/home_view.dart';
import 'home/logout.dart';
import 'localStorage/local_storage.dart';
import 'history/history_page.dart';
import 'todolist/todolist_page.dart';
import 'todolist/popup.dart';
import 'todolist/addtransaction_page.dart';
import 'home/addapprove_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var logedin = await getValueBool('is_logedin');
  print('telah login : $logedin');
  runApp(MaterialApp(
    // initialRoute: '/', // Set the initial route
    home: logedin ? HomeView() : LoginForm(),
    routes: {
      '/login': (context) => LoginForm(), // Route for the login page
      '/home': (context) => HomeView(),//Route for the home page
      '/logout': (contet) => LogoutScreen(),
      '/history': (context) => HistoryPage(),
      '/todolist': (context) => TodoListPage(),
      '/popup': (context) => Popup(),
      '/todoadd-transaction': (context) => AddTransactionPage(),
      '/add-transaction': (context) => AddTransactionApprove(),
      // '/signup': (context) => // Route for the signup page
    },
  ));
}
