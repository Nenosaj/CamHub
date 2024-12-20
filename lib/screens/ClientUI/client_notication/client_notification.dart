import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Paymongo/payment.dart'; // Import for payment page

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
    fetchBookings().then((bookings) {
      setState(() {
        notifications = bookings;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchBookings() async {
    List<Map<String, dynamic>> clientBookings = [];

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print("No user is logged in.");
        return [];
      }

      // Query Firestore for bookings where clientId matches the current user
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('clientId', isEqualTo: currentUser.uid)
          .get();

      // Parse the documents into a list of maps
      clientBookings = bookingsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['bookingId'] = doc.id; // Add document ID
        return data;
      }).toList();

      print('Fetched ${clientBookings.length} bookings for the client.');
      return clientBookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  void deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
      setState(() {
        notifications.removeWhere(
            (notification) => notification['bookingId'] == bookingId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking deleted successfully.')),
      );
    } catch (e) {
      print('Error deleting booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete booking.')),
      );
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
                  final bool isApproved = notification['approved'] ?? false;
                  final bool isDeclined = notification['declined'] ?? false;
                  final String reason =
                      notification['reason'] ?? 'No reason provided';

                  return AnimatedSlide(
                    offset: _isCardVisible
                        ? const Offset(0, 0)
                        : const Offset(0, 1),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    child: NotificationCard(
                      title: 'Booking',
                      subtitle: isApproved
                          ? 'Status: Approved ✅'
                          : isDeclined
                              ? 'Status: Declined ❌'
                              : 'Status: Pending ⏳',
                      message: isApproved
                          ? 'Your appointment has been approved. Please proceed to payment.'
                          : isDeclined
                              ? 'Your appointment was declined. Reason: $reason'
                              : 'Your appointment is still pending. Please wait for confirmation.',
                      buttonText: isApproved ? 'Proceed to Payment' : 'Close',
                      reason: isDeclined ? reason : null,
                      onPressed: isApproved
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Payment(
                                    bookingId: notification['bookingId'],
                                  ),
                                ),
                              );
                            }
                          : null,
                      onDelete: isDeclined
                          ? () {
                              deleteBooking(notification['bookingId']);
                            }
                          : null,
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
  final String? reason;
  final VoidCallback? onPressed;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.buttonText,
    this.reason,
    this.onPressed,
    this.onDelete,
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
            if (reason != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Reason: $reason",
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (onPressed != null)
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF662C2B),
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText),
              ),
            if (onDelete != null)
              ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Delete"),
              ),
          ],
        ),
      ),
    );
  }
}
