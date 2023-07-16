import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:money_tracker/localStorage/local_storage.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  String selectedStatus = 'Semua transaksi';
  String selectedApproved = 'false';
  List<Transaction> transactions = [];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todolist'),
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
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
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
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedApproved,
                    decoration: InputDecoration(
                      labelText: 'Approved',
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text('Semua'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'true',
                        child: Text('Approved'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'false',
                        child: Text('Belum approved'),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        selectedApproved = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                getTodos();
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
                      tileColor: transactions[index].status == 'in' ? Colors.green.shade200 : Colors.red.shade200,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transactions[index].name ?? '',
                                style: TextStyle(fontSize: 19, color: Colors.black),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: transactions[index].isApprove != false
                                    ? Text(
                                        'Approved',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green.shade900,
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Action when remove icon is pressed
                                              // Example: removeTransaction(transactions[index]);
                                            },
                                            icon: Icon(Icons.remove, color: Colors.red),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Action when approve icon is pressed
                                              // Example: approveTransaction(transactions[index]);
                                            },
                                            icon: Icon(Icons.approval, color: Colors.blue),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            transactions[index].amount != null ? transactions[index].amount.toString() : '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Created: ' +
                                    (transactions[index].createdDate != null ? formatDate(transactions[index].createdDate) : ''),
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  (transactions[index].approvalDate != ''
                                      ? 'Approved: ' + formatDate(transactions[index].approvalDate)
                                      : ''),
                                  style: TextStyle(fontSize: 15, color: Colors.black),
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
    );
  }

  void getTodos() async {
    try {
      // Lakukan pemanggilan ke API /get-history dengan parameter yang diperlukan
      String fromDate = fromDateController.text.isEmpty ? '' : fromDateController.text;
      String toDate = toDateController.text.isEmpty ? '' : toDateController.text;
      String approved = selectedApproved.isEmpty ? '' : selectedApproved;
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
        Uri.parse('${url_api}?from_date_created=${fromDate}&to_date_created=${toDate}&status=$status&user_id=$userId&is_approved=$approved'),
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

  String formatDate(String dateData) {
    if(dateData.isEmpty) return '';
    DateTime date = DateTime.parse(dateData);
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
  final int transactionId;
  final bool isApprove;

  Transaction({required this.name, required this.amount, 
    required this.status, required this.approvalDate, 
    required this.createdDate, required this.transactionId,
    required this.isApprove});
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
  return Transaction(
    transactionId: json['id'],
    name: json['name'],
    amount: json['nominal'] != null ? json['nominal'].toDouble() : null,
    status: json['status'],
    approvalDate: json['approved_at'] != null ? json['approved_at'] : '',
    createdDate: json['created_at'] != null ? json['created_at'] : '',
    isApprove: json['is_approve'] != null ? json['is_approve'] : '',
  );
}
}