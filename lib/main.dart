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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/admin': (context) => const AdminUI(),
        '/client': (context) => const ClientUI(),
        '/creative': (context) => const CreativeUI(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}
