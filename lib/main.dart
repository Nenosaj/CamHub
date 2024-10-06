import 'package:flutter/material.dart';
import 'screens/loginscreen.dart';
import 'screens/registration/signupscreen.dart';
import 'screens/AdminUI/admin_ui.dart';
import 'screens/ClientUI/client_ui.dart';
import 'screens/CreativeUI/creative_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Role-Based App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // jason
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/admin': (context) =>  AdminUI(),
        '/client': (context) => ClientUI(),
        '/creative': (context) =>  CreativeUI(),
        '/signup': (context) =>  SignUpScreen(),
      },
    );
  }
}
