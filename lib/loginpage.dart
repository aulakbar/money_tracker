import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Define the API endpoint
const String apiUrl = 'https://a31c-104-28-250-135.ngrok-free.app';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Username and password
  late String _username;
  late String _password;

  // Handler for the login button
  void _onLoginPressed() async {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Make a POST request to the API
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': _username,
          'password': _password,
        },
      );

      // Check the response status code
      if (response.statusCode == 200) {
        // Navigate to the home screen
        Navigator.pushNamed(context, '/home');
      } else {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
        print("Login Failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text('Money Tracker'),
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
                  labelText: 'Username',
                  filled: true,
                  icon: const Icon(Icons.person),
                ),
                onChanged: (value) => _username = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              sizedBoxSpace,
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onLoginPressed,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
