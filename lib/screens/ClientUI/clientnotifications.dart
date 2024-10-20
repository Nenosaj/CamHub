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
