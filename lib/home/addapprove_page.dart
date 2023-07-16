import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:money_tracker/localStorage/local_storage.dart';

class AddTransactionApprove extends StatefulWidget {
  @override
  _AddTransactionApproveState createState() => _AddTransactionApproveState();
}

class _AddTransactionApproveState extends State<AddTransactionApprove> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name = '';
  String? _description = '';
  int? _nominal = 0;
  String? _status = '';

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction added successfully!'),
      ),
    );
  }

  Future<void> _submitForm() async {
    final form = _formKey.currentState;
    if (form?.validate() ?? false) {
      form?.save();

      setState(() {
        _isLoading = true;
      });

      // Kirim data ke API
      try {
        String? token = await getValueString('token');
        var headers = {'x-token': token}.cast<String, String>();
        int? userId = await getValueInt('user_id');
        var body = jsonEncode({
            'name': _name,
            'description': _description,
            'nominal': _nominal.toString(),
            'status': _status,
            'user_id': userId,
            'is_approve': true,
          });
        final response = await http.post(
          Uri.parse('https://4f4c-125-164-16-190.ngrok-free.app/pocket-flow/'),
          headers:headers,
          body: body,
        );

        if (response.statusCode == 200) {
          setState(() {
            _isSuccess = true;
          });
          _showSuccessSnackbar();
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else {
          print('Request failed with status: ${response.statusCode}');
          setState(() {
            _isSuccess = false;
          });
        }
      } catch (error) {
        // Jika terjadi error pada koneksi atau server
        print('Error: $error');
        setState(() {
          _isSuccess = false;
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a nominal';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a nominal';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nominal'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nominal';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nominal = value != null ? int.parse(value) : null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(
                    value: 'in',
                    child: Text('Transaksi Masuk'),
                  ),
                  DropdownMenuItem(
                    value: 'out',
                    child: Text('Transaksi Keluar'),
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return 'Please select a status';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
                onSaved: (value) {
                  _status = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Submit'),
              ),
              if (_isSuccess)
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Transaction added successfully!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Navigator.pushReplacementNamed(context, '/todolist');
            ],
          ),
        ),
      ),
    );
  }
}
