import 'package:flutter/material.dart';
import 'balance_card.dart';
import 'cashflow.dart';
import 'user_data.dart';
import '../localStorage/local_storage.dart';
// import './logout.dart'; // File logout

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  dynamic userDetails;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Wrap the screen with WillPopScope to handle system back button
      onWillPop: () async {
        // Remove the previous route from the stack
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
        return false; // Prevent going back
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Pocket'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showLogoutDialog(context); // Show logout confirmation dialog
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${userDetails != null ? 'Hello '+userDetails['name'] : 'Loading..'}!', // Menggunakan email jika userDetails tidak null
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BalanceCard(),
              SizedBox(height: 16.0),
              TransactionList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-transaction');
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Histori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Todo List',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                // Navigasi ke halaman histori
                Navigator.pushReplacementNamed(context, '/history');
              } else if (_selectedIndex == 1) {
                // Navigasi ke halaman tambah
                Navigator.pushReplacementNamed(context, '/home');
              } else if (_selectedIndex == 2) {
                // Navigasi ke halaman to-do list
                Navigator.pushReplacementNamed(context, '/todolist');
              }
            });
          },
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/logout', // Replace '/login' with the route name for your login screen
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  //Memanggil data user Detail dari API
  void getUserDetail() async {
    try {
      int? userId = await getValueInt('user_id');
      dynamic userDetailsData = await user_data.getUserDetail("$userId"); // user_id yang disimpan ketika berhasil login
      setState(() {
        userDetails = userDetailsData;
      });
      print(userDetails);
      // Lakukan tindakan lain dengan data pengguna
    } catch (e) {
      print(e);
      // Tangani kesalahan saat memanggil API
    }
  }
}
