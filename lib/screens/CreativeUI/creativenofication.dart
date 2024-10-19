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
  _CreativeNotificationPageState createState() =>
      _CreativeNotificationPageState();
}

class _CreativeNotificationPageState extends State<CreativeNotificationPage> {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          backgroundColor: const Color(0xFF662C2B), // Maroon color for the AppBar
          elevation: 0,
          title: const Text(
            'Creative Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 16),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
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
