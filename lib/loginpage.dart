import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Define the API endpoint
const String apiUrl = 'https://money-tracker-production-3bd6.up.railway.app/auth/login';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Username and password
  late String? _email;
  late String? _password;

  @override
  void initState() {
  _email = "Flutter Campus";
  _password = "test";
  super.initState();
}

  // Handler for the login button
  void _onLoginPressed() async {
  if (_formKey.currentState!.validate()) {
    if (_email != null && _password != null) {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "email": _email,
          "password": _password,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login success')),
        );
        // Navigate to the home screen
        // Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
        print("Login Failed");
      }
    } else {
      // Handle the case when _email or _password is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or password is missing')),
      );
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
                  labelText: 'email',
                  filled: true,
                  icon: const Icon(Icons.person),
                ),
                onChanged: (value) => _email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
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
