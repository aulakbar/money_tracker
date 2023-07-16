import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:money_tracker/localStorage/local_storage.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String selectedStatus = 'Semua transaksi';
  List<Transaction> transactions = [];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: fromDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Dari Tanggal',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                fromDateController.text =
                                    selectedDate.toString().split(' ')[0];
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    controller: toDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Sampai Tanggal',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                toDateController.text =
                                    selectedDate.toString().split(' ')[0];
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
              ),
              items: [
                'Semua transaksi',
                'Transaksi masuk',
                'Transaksi keluar',
              ]
                  .map((status) => DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                getHistory();
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transactions[index].name ?? '',
                            style: TextStyle(fontSize: 19)
                          ),
                          SizedBox(height: 5),
                          Text(
                            transactions[index].amount != null 
                              ? transactions[index].status == 'in' 
                                ? '+'+NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(transactions[index].amount)
                                : '-'+NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(transactions[index].amount)
                              : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: transactions[index].status == 'in' ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Created: ' + (transactions[index].createdDate != null ? formatDate(transactions[index].createdDate) : ''),
                                style: TextStyle(fontSize: 15),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  (transactions[index].approvalDate != null ? 'Approved: '+ formatDate(transactions[index].approvalDate) : ''),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
    );
  }

  void getHistory() async {
    try {
      // Lakukan pemanggilan ke API /get-history dengan parameter yang diperlukan
      String fromDate = fromDateController.text.isEmpty ? '' : fromDateController.text;
      String toDate = toDateController.text.isEmpty ? '' : toDateController.text;
      String status;
      if (selectedStatus == 'Semua transaksi') {
        status = '';
      } else if (selectedStatus == 'Transaksi masuk') {
        status = 'in';
      } else if (selectedStatus == 'Transaksi keluar') {
        status = 'out';
      } else {
        status = '';
      }
      String? token = await getValueString('token');
      var headers = {'x-token': token}.cast<String, String>();
      int? userId = await getValueInt('user_id');
      String url_api = 'https://4f4c-125-164-16-190.ngrok-free.app/pocket-flow/';
      var response = await http.get(
        Uri.parse('${url_api}?from_date_approved=${fromDate}&to_date_approved=${toDate}&status=$status&user_id=$userId&is_approved=true&orderby=approved&ordered=desc'),
        headers: headers
      );
      if (response.statusCode == 200) {
        // Parsing respon JSON ke dalam list of transactions
        var data = json.decode(response.body);
        List<Transaction> fetchedTransactions = [];
        for (var transactionData in data) {
          fetchedTransactions.add(Transaction.fromJson(transactionData));
        }
        // print(response.body);
        setState(() {
          transactions = fetchedTransactions;
        });
      } else {
        print('Failed to fetch history');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatDate(String approvalDate) {
    if(approvalDate.isEmpty) return '';
    DateTime date = DateTime.parse(approvalDate);
    String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return formattedDate;
  }
}

class Transaction {
  final String name;
  final double? amount;
  final String? status;
  final String approvalDate;
  final String createdDate;

  Transaction({required this.name, required this.amount, 
    required this.status, required this.approvalDate, required this.createdDate});

  factory Transaction.fromJson(Map<String, dynamic> json) {
  return Transaction(
    name: json['name'],
    amount: json['nominal'] != null ? json['nominal'].toDouble() : null,
    status: json['status'],
    approvalDate: json['approved_at'] != null ? json['approved_at'] : '',
    createdDate: json['created_at'] != null ? json['created_at'] : '',
  );
}
}
