import 'package:flutter/material.dart';

void main() {
  runApp(Popup());
}

class Popup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popup Filter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  bool isFilterVisible = false;
  String selectedStatus = 'Semua transaksi';

  void toggleFilter() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popup Filter Example'),
      ),
      body: Stack(
        children: [
          // Tombol Filter
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: toggleFilter,
                child: Text('Filter'),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: isFilterVisible ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.white,
              child: Column(
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
                                      fromDateController.text = selectedDate.toString().split(' ')[0];
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
                                      toDateController.text = selectedDate.toString().split(' ')[0];
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
                      // getTodos();
                    },
                    child: Text('Search'),
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: toggleFilter,
                    child: Text('less'),
                  ),
                ],
              ),
),

          ),
          // Daftar Transaksi
          
        ],
      ),
    );
  }
}
