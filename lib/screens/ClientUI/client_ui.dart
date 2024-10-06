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
        appBarTheme: AppBarTheme(
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
        '/': (context) => HomePage(), // HomePage as the default route
        '/chat': (context) =>
            ChatScreen(), // Define ChatPage in a separate file
        '/bookings': (context) =>
            BookingPage(), // Define BookingsPage in a separate file
        '/notifications': (context) =>
            NotificationPage(), // Define NotificationsPage in a separate file
        '/profile': (context) =>
            ProfilePage(), // Define ProfilePage in a separate file
      },
    );
  }
}
