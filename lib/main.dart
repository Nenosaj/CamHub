import 'package:flutter/material.dart';
import 'screens/loginscreen.dart';
import 'screens/signupscreen.dart';
import 'screens/AdminUI/admin_ui.dart';
import 'screens/ClientUI/client_ui.dart';
import 'screens/CreativeUI/creative_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role-Based App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Start with the login screen
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/admin': (context) => AdminUI(),
        '/client': (context) => ClientUI(),
        '/creative': (context) => CreativeUI(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}