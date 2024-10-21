import 'package:flutter/material.dart';
import 'clienthomepage.dart';
import 'clientbookings.dart';
import 'clientmessage.dart';
import 'clientnotifications.dart';
import 'clientProfile.dart';

class ClientUI extends StatelessWidget {
  const ClientUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CamHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white, // Sets the title text to white
            fontSize: 20, // You can adjust the size if needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Start with the HomePage or other routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(), 
        '/chat': (context) =>
            const ChatScreen(), 
        '/bookings': (context) =>
            const BookingPage(), 
        '/notifications': (context) =>
            const NotificationPage(),
        '/profile': (context) =>
            const ProfilePage(),
      },
    );
  }
}
