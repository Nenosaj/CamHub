import 'package:flutter/material.dart';
import 'creativenotification_card.dart'; // Import the Creative Notification Card

// Mock data (which can later be integrated with backend)
const List<Map<String, dynamic>> creativeNotifications = [
  {
    "title": "Appointment Request",
    "message": "A new client has requested an appointment.",
    "time": "08:31 PM",
    "isNew": true,
  },
  {
    "title": "Appointment Request",
    "message": "A new client has requested an appointment.",
    "time": "10:00 AM",
    "isNew": false,
  },
  {
    "title": "Payment Transferred",
    "message": "Payment has been successfully transferred to your account.",
    "time": "Yesterday",
    "isNew": false,
  },
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreativeNotificationPage(),
    );
  }
}

class CreativeNotificationPage extends StatefulWidget {
  const CreativeNotificationPage({super.key});

  @override
  CreativeNotificationPageState createState() =>
      CreativeNotificationPageState();
}

class CreativeNotificationPageState extends State<CreativeNotificationPage> {
  bool _isCardVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isCardVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        toolbarHeight: 80.0,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: creativeNotifications.map((notification) {
            return AnimatedSlide(
              offset: _isCardVisible ? const Offset(0, 0) : const Offset(0, 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: CreativeNotificationCard(
                title: notification['title'],
                message: notification['message'],
                time: notification['time'],
                isNew: notification['isNew'],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
