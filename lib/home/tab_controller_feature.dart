import 'package:flutter/material.dart';
import 'user_data.dart';
import '../localStorage/local_storage.dart';
// import './logout.dart'; // File logout

List<Transaction> transactionHistory = [];
TextEditingController _amountController = TextEditingController();

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  dynamic userDetails;
  TabController? _tabController;
  bool _isIncome = true;

  void _addAmount(double amount) {
    setState(() {
      transactionHistory.add(
        Transaction(
          amount: amount,
          isIncome: _isIncome,
        ),
      );
      _amountController.clear(); // Clear the text field
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
    _tabController = TabController(length: 2, vsync: this);
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            title: Text('My Pocket'),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'History'),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hello ${userDetails != null ? userDetails['name'] : 'User'}!',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TransactionSummaryCard(
                      transactionHistory: transactionHistory),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        double amount = double.parse(_amountController.text);
                        _addAmount(amount);
                      },
                      child: Text('Add amount'))
                ],
              ),
            ),
            TransactionTab(),
          ],
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
      dynamic userDetailsData = await user_data.getUserDetail(
          "$userId"); // user_id yang disimpan ketika berhasil login
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

class TransactionTab extends StatefulWidget {
  @override
  _TransactionTabState createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  bool _sortAscending = true;

  void _sortTransactionsAscending() {
    setState(() {
      _sortAscending = true;
      _quickSort(transactionHistory, 0, transactionHistory.length - 1);
    });
  }

  void _sortTransactionsDescending() {
    setState(() {
      _sortAscending = false;
      _quickSort(transactionHistory, 0, transactionHistory.length - 1);
    });
  }

//Algortima quicksort
  void _quickSort(List<Transaction> transactions, int low, int high) {
    if (low < high) {
      int pivotIndex = _partition(transactions, low, high);
      _quickSort(transactions, low, pivotIndex - 1);
      _quickSort(transactions, pivotIndex + 1, high);
    }
  }

  int _partition(List<Transaction> transactions, int low, int high) {
    Transaction pivot = transactions[high];
    int i = low - 1;

    for (int j = low; j < high; j++) {
      if ((_sortAscending && transactions[j].amount <= pivot.amount) ||
          (!_sortAscending && transactions[j].amount >= pivot.amount)) {
        i++;
        _swap(transactions, i, j);
      }
    }

    _swap(transactions, i + 1, high);
    return i + 1;
  }

  void _swap(List<Transaction> transactions, int i, int j) {
    Transaction temp = transactions[i];
    transactions[i] = transactions[j];
    transactions[j] = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 4.0,
            margin: EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: transactionHistory.length,
              itemBuilder: (context, index) {
                Transaction transaction = transactionHistory[index];
                String type = transaction.amount >= 0 ? 'Income' : 'Outcome';

                return ListTile(
                  title:
                      Text('$type: \$${transaction.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sort by Amount:'),
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      _sortTransactionsAscending();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      _sortTransactionsDescending();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Transaction {
  final double amount;
  final bool isIncome;

  Transaction({required this.amount, required this.isIncome});
}

class TransactionSummaryCard extends StatelessWidget {
  final List<Transaction> transactionHistory;

  const TransactionSummaryCard({required this.transactionHistory});

  @override
  Widget build(BuildContext context) {
    double totalAmount = _calculateTotalAmount();

    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Summary',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalAmount() {
    double totalAmount = 0.0;
    for (var transaction in transactionHistory) {
      totalAmount += transaction.amount;
    }
    return totalAmount;
  }
}
