import 'package:example/screens/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/loginscreen.dart';
import 'screens/registration/signupscreen.dart';
import 'screens/AdminUI/admin_ui.dart';
import 'screens/ClientUI/client_ui.dart';
import 'screens/CreativeUI/creative_ui.dart';
//import 'package:example/screens/loadingstate.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => WelcomePage(), // Welcome page as the initial route
        '/login': (context) => const LoginScreen(), // Login route
        '/admin': (context) => const AdminUI(), // Admin route
        '/client': (context) => const ClientUI(), // Client route
        '/creative': (context) => const CreativeUI(), // Creative route
        '/signup': (context) => const SignUpScreen(), // Signup route
      },
    );
  }
}
