import 'package:flutter/material.dart';
import 'clientnotification_card.dart'; // Import the new file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
          backgroundColor: const Color(0xFF7B3A3F),
          elevation: 0,
          title: const Text(
            'Notifications',
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(fontSize: 16),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedSlide(
              offset: _isCardVisible ? Offset(0, 0) : Offset(0, 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: NotificationCard(
                title: 'Booking',
                subtitle: 'Appointment Confirmation',
                message:
                    'Hello Client,\nYour appointment has been confirmed. Please pay for the initial payment to proceed with the booking.',
                buttonText: 'Proceed to Payment',
                onPressed: () {
                  // Action for button press
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
