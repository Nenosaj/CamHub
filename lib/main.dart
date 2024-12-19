import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/LogIn/loginscreen.dart';
import 'screens/SignUp/signupscreen.dart';
import 'screens/AdminUI/admin_ui.dart';
import 'screens/ClientUI/client_ui.dart';
import 'screens/CreativeUI/creative_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/SignUp/autocomplete_address/geoapify_address.dart'; // Import for API function

//import 'package:example/screens/loadingstate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "firebase.env");
  } catch (e) {
    // ignore: avoid_print
    print("Error loading .env file: $e");
  }

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['apiKey'] ?? '',
        authDomain: dotenv.env['authDomain'] ?? '',
        projectId: dotenv.env['projectId'] ?? '',
        storageBucket: dotenv.env['storageBucket'] ?? '',
        messagingSenderId: dotenv.env['messagingSenderId'] ?? '',
        appId: dotenv.env['appId'] ?? '',
        measurementId: dotenv.env['measurementId'] ?? '',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
