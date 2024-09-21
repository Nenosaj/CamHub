import 'package:flutter/material.dart';
import 'clienthomepage.dart'; // Import the homepage.dart file

class ClientUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role-Based App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Start with the HomePage or other routes
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(), // HomePage as the default route
        //'/chat': (context) => ChatPage(), // Define ChatPage in a separate file
        //'/bookings': (context) => BookingsPage(), // Define BookingsPage in a separate file
        //'/notifications': (context) => NotificationsPage(), // Define NotificationsPage in a separate file
        //'/profile': (context) => ProfilePage(), // Define ProfilePage in a separate file
      },
    );
  }
}
