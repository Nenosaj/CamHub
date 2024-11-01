import 'package:flutter/material.dart';
import 'clientnotification_card.dart'; // Import the new file
import 'package:example/screens/ClientUI/client_notication/client_initialpayment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
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
              offset: _isCardVisible ? const Offset(0, 0) : const Offset(0, 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: NotificationCard(
                title: 'Booking',
                subtitle: 'Appointment Confirmation',
                message:
                    'Hello Client,\nYour appointment has been confirmed. Please pay for the initial payment to proceed with the booking.',
                buttonText: 'Proceed to Payment',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InitialPayment(
                        selectedAddOns: {
                          "Drone Shot": true,
                          "5 more pictures": true,
                          "1-minute video": false,
                          // Add other add-ons as necessary
                        },
                        addOnPrices: {
                          "Drone Shot": "₱3,000",
                          "5 more pictures": "₱500",
                          "1-minute video": "₱1,000",
                          // Add other prices as necessary
                        },
                        totalCost:
                            14500, // Example total cost; replace with your calculation
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
