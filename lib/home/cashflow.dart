import 'package:flutter/material.dart';


class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Recent Transactions',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TransactionItem(
          title: 'Payment Received',
          subtitle: 'John Doe',
          amount: '+\$100.00',
          date: '24 June 2023',
        ),
        TransactionItem(
          title: 'Payment Sent',
          subtitle: 'Jane Smith',
          amount: '-\$50.00',
          date: '23 June 2023',
        ),
        TransactionItem(
          title: 'Payment Received',
          subtitle: 'Bob Johnson',
          amount: '+\$75.00',
          date: '22 June 2023',
        ),
      ],
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String date;

  TransactionItem({
    this.title = '',
    this.subtitle = '',
    this.amount = '',
    this.date = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: amount.startsWith('-') ? Colors.red : Colors.green,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            date,
            style: TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}