import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'client_initialpayment.dart'; // Import for payment page

class ClientNotificationPage extends StatefulWidget {
  const ClientNotificationPage({super.key});

  @override
  State<ClientNotificationPage> createState() => _ClientNotificationPageState();
}

class _ClientNotificationPageState extends State<ClientNotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isCardVisible = false;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isCardVisible = true;
      });
    });
    fetchBookings();
  }

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    List<Map<String, dynamic>> allBookings = [];

    try {
      // Step 1: Fetch all creativeId documents in 'bookings'
      QuerySnapshot bookingsSnapshot =
          await _firestore.collection('bookings').get();

      // Step 2: Iterate through each document (each creativeId)
      for (QueryDocumentSnapshot creativeDoc in bookingsSnapshot.docs) {
        String creativeId = creativeDoc.id;

        // Step 3: Access the data inside the creative's bookings
        final bookingData = creativeDoc.data() as Map<String, dynamic>? ?? {};

        allBookings.add({
          'creativeId': creativeId, // Include creativeId for reference
          'bookingDetails': bookingData['bookingDetails'] ?? {},
          'createdAt': bookingData['createdAt'] ?? Timestamp.now(),
        });
      }

      print('Fetched ${allBookings.length} bookings.');
      return allBookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
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
      body: notifications.isEmpty
          ? const Center(child: Text("No notifications available."))
          : SingleChildScrollView(
              child: Column(
                children: notifications.map((notification) {
                  return AnimatedSlide(
                    offset: _isCardVisible
                        ? const Offset(0, 0)
                        : const Offset(0, 1),
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
                            builder: (context) => InitialPayment(
                              selectedAddOns: notification['bookingDetails']
                                      ['addOns'] ??
                                  {},
                              addOnPrices: const {
                                "Drone Shot": "₱3,000",
                                "5 more pictures": "₱500",
                                "1-minute video": "₱1,000",
                              },
                              totalCost: notification['bookingDetails']
                                      ['totalCost'] ??
                                  14500,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF662C2B),
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
