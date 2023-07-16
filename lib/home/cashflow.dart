import 'package:flutter/material.dart';
import 'user_data.dart';
import 'package:money_tracker/localStorage/local_storage.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<TransactionList> {
  String selectedStatus = 'Semua transaksi';
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    getTransaction();
  }

  Future<void> getTransaction() async {
    try {
      String status;
      if (selectedStatus == 'Semua transaksi')
        status = '';
      else if (selectedStatus == 'Transaksi masuk')
        status = 'in';
      else if (selectedStatus == 'Transaksi keluar')
        status = 'out';
      else
        status = '';
      int? userId = await getValueInt('user_id');
      final data = await user_data.getPocketFlow("$userId", 5, status);
      // print(data);
      List<Transaction> fetchedTransactions = [];
      for (var transactionData in data) {
        fetchedTransactions.add(Transaction.fromJson(transactionData));
      }
      // print(response.body);
      setState(() {
        transactions = fetchedTransactions;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
              // getHistory();
              getTransaction();
            },
            child: Text('Search'),
          ),
          SizedBox(height: 16.0),
          Text(
            'New Transactions',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          // SizedBox(height: 8.0),
          // SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( //name
                            transactions[index].name ?? '',
                            style: TextStyle(fontSize: 19)),
                        SizedBox(height: 5),
                        Text( // amount
                          transactions[index].amount != null
                              ? transactions[index].status == 'in'
                                  ? '+' +
                                      NumberFormat.currency(
                                              locale: 'id_ID', symbol: 'Rp')
                                          .format(transactions[index].amount)
                                  : '-' +
                                      NumberFormat.currency(
                                              locale: 'id_ID', symbol: 'Rp')
                                          .format(transactions[index].amount)
                              : '',
                          style: TextStyle(
                            fontSize: 18,
                            color: transactions[index].status == 'in'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Created: ' +
                                  (transactions[index].createdDate != null
                                      ? formatDate(
                                          transactions[index].createdDate)
                                      : ''),
                              style: TextStyle(fontSize: 15),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (transactions[index].approvalDate != null
                                    ? 'Approved: ' +
                                        formatDate(
                                            transactions[index].approvalDate)
                                    : ''),
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
    );
  }

  String formatDate(String dateData) {
    if (dateData.isEmpty) return '';
    DateTime date = DateTime.parse(dateData);
    String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return formattedDate;
  }
}

class Transaction {
  final String name;
  final double? amount;
  final String? status;
  final String approvalDate;
  final String createdDate;

  Transaction(
      {required this.name,
      required this.amount,
      required this.status,
      required this.approvalDate,
      required this.createdDate});

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
