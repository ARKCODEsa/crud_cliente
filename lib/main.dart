import 'package:flutter/material.dart';
import 'package:crud_cliente/login/Login.dart';
import 'package:crud_cliente/check_in/check_In.dart';
import 'package:crud_cliente/customer/Customer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Customer',
      initialRoute: '/welcome',
      routes: {
        '/': (context) => const Login(),
        '/check_in': (context) => const Check_In(),
        '/Customer': (context) => const CustomerPage(),
        '/welcome': (context) => const Welcome(),
        // Add other routes here
      },
    );
  }
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to CRUD Customer',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}