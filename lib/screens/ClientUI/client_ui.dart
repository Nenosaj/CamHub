import 'package:example/screens/ClientUI/client_message/client_message.dart';
import 'package:example/screens/ClientUI/client_message/client_userlistscreen.dart';
import 'package:flutter/material.dart';
import 'client_homepage/client_homepage.dart';
import 'client_booking/client_booking.dart';
import 'client_notication/client_notification.dart';
import 'client_profile/client_profile.dart';

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
        '/': (context) => const ClientHomePage(),
        '/chat': (context) =>
            const UserListScreen(), // Use default values or dynamic fetching within ChatScreen,
        '/bookings': (context) => const BookingPage(),
        '/notifications': (context) => const ClientNotificationPage(),
        '/profile': (context) => const ClientProfilePage(),
      },
    );
  }
}
