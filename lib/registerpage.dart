import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define the API endpoint
const String apiUrl = 'https://money-tracker-production-3bd6.up.railway.app/auth/register';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _password;

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      // Perform registration logic here
      var body = jsonEncode({
        'name': _name,
        'email': _email,
        'password': _password,
        'id_level': 2
      });
      final response = await http.post(
        Uri.parse('$apiUrl'), // Modify the API endpoint for registration
        body: body,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        // Registration successful, show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );

        // Reset the form after registration
        _formKey.currentState!.reset();
      } else {
        // Registration failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
        print("Registration Failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            children: [
              sizedBoxSpace,
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  icon: const Icon(Icons.person),
                ),
                onChanged: (value) => _name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              sizedBoxSpace,
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  icon: const Icon(Icons.email),
                ),
                onChanged: (value) => _email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  // You can add more complex email validation logic here if needed
                  return null;
                },
              ),
              sizedBoxSpace,
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  icon: const Icon(Icons.lock),
                ),
                onChanged: (value) => _password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              sizedBoxSpace,
              ElevatedButton(
                onPressed: _onRegisterPressed,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
