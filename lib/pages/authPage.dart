import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void popUpCenter (String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade600,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ), // Text ), // Center
          ),
        );
      },
    );// AlertDialog
  }

  void checkToken() async {
    // Check if token exists
    String? token = await storage.read(key: 'token');
    if (token != null) {
      // Token exists, navigate to the homepage
      Navigator.pushReplacementNamed(context, '/homepage');
      popUpCenter('Token present');
    }
    else {
      // Token doesn't exist, navigate to the login page
      // Navigator.pushReplacementNamed(context, '/loginpage');
      // Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/homepage');
      popUpCenter('Token absent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Display a loading indicator while checking token
      ),
    );
  }
}
