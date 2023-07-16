import 'package:flutter/material.dart';
import 'dart:convert';
import 'user_data.dart';
import 'package:http/http.dart' as http;
import 'package:money_tracker/localStorage/local_storage.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatefulWidget {
  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  Map<String, dynamic> myData = {};
  num totalIn = 0;
  num totalOut = 0;
  List<dynamic> inTransaction = [];
  List<dynamic> outTransaction = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    transactionIn();
    transactionOut();
  }

  Future<void> fetchData() async {
    try {
      int? userId = await getValueInt('user_id');
      final data = await user_data.getUserDetail("$userId");
      setState(() {
        myData = data;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> transactionIn() async {
    try{
      int? userId = await getValueInt('user_id');
      final data = await user_data.getPocketFlow("$userId",5,'in');
      num totalMoney = 0; // Change type to num
      for (var transaction in data) {
        totalMoney += int.parse(transaction['nominal'].toString()); // Convert and accumulate the money value
      }
      setState(() {
        inTransaction = data;
        totalIn = totalMoney;
      });
    } catch (e){
      print('Error: $e');
    }
  }

  Future<void> transactionOut() async {
    try{
      int? userId = await getValueInt('user_id');
      final data = await user_data.getPocketFlow("$userId",5,'out');
      num totalMoney = 0; // Change type to num
      for (var transaction in data) {
        totalMoney += int.parse(transaction['nominal'].toString()); // Convert and accumulate the money value
      }
      setState(() {
        outTransaction = data;
        totalOut = totalMoney;
      });
    } catch (e){
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Balance',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Builder(
              builder: (context) {
                final myBalance = myData != null && myData['my_pocket'] != null && myData['my_pocket'].isNotEmpty
                    ? NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(myData['my_pocket'][0]['money'])
                    : 'Loading...';

                return Text(
                  '$myBalance',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 8.0),
            // Text(
            //   'Last updated: 25 June 2023',
            //   style: TextStyle(
            //     fontSize: 12.0,
            //     color: Colors.grey,
            //   ),
            // ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Uang Masuk',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${totalIn != 0 ? '+'+NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(totalIn) ?? 'Loading...' : 'Loading...'}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Uang Keluar',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '${totalOut != 0 ? '-'+NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(totalOut) ?? 'Loading...' : 'Loading...'}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

