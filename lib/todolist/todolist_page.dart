import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:money_tracker/localStorage/local_storage.dart';
import 'package:intl/intl.dart';
import 'todoService.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  bool isExpanded = false;

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
            
            isExpanded
                ? Column(
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
                        getTodos();
                      },
                      child: Text('Search'),
                    ),
                    SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = false;
                          });
                        },
                        child: Text('Show less'),
                      ),
                    ],
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        isExpanded = true;
                      });
                    },
                    child: Text('Show more'),
                  ),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(transactions[index].name ?? '',
                                style: TextStyle(fontSize: 19)
                              ),
                    
                              Align(
                              alignment: Alignment.centerRight,
                              child: transactions[index].isApprove != false
                                  ? Text('Approved',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            return showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Konfirmasi'),
                                                  content: Text('Apakah Anda yakin ingin Menghapus?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Tidak'),
                                                      onPressed: () {
                                                        // Tindakan ketika tombol "Tidak" ditekan
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Yakin'),
                                                      onPressed: () async {
                                                        final data = await todoService.deleteTodo(transactions[index].transactionId);
                                                        if(data == true){
                                                          // Navigator.of(context).pop();
                                                          sweatAlertSuccess(context,"Penghapusan berhasil");
                                                          getTodos();
                                                        }
                                                        print(data);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.delete_outlined, color: Colors.red),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            return showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Konfirmasi'),
                                                  content: Text('Apakah Anda yakin ingin menyetujui?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Tidak'),
                                                      onPressed: () {
                                                        // Tindakan ketika tombol "Tidak" ditekan
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Yakin'),
                                                      onPressed: () async {
                                                        final data = await todoService.approveTodo(transactions[index].transactionId);
                                                        if(data == true){
                                                          // Navigator.of(context).pop();
                                                          sweatAlertSuccess(context, "Penyetujian berhasil");
                                                          getTodos();
                                                        }
                                                        print(data);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            
                                          },
                                          icon: Icon(Icons.check, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                            ]
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
                                  (transactions[index].approvalDate != '' ? 'Approved: '+ formatDate(transactions[index].approvalDate) : ''),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/todoadd-transaction');
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
        Uri.parse('${url_api}?from_date_created=${fromDate}&to_date_created=${toDate}&status=$status&user_id=$userId&is_approved=$approved&orderby=created&ordered=desc'),
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

  void sweatAlertSuccess(BuildContext context, String title) {
    Alert(
      context: context,
      type: AlertType.success,
      title: title,
      // desc: "Selamat anda berhasil login",
      buttons: [
        DialogButton(
          child: Text(
            "Selanjutnya",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        )
      ],
    ).show();
    return;
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
