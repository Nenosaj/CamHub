import 'package:example/screens/responsive_helper.dart';
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

      for (var doc in bookingsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['bookingId'] = doc.id; // Add document ID

        // Fetch payment subcollection for this booking
        QuerySnapshot paymentSnapshot = await _firestore
            .collection('bookings')
            .doc(doc.id)
            .collection('payment')
            .get();

        // Check if any payment document has `paid` set to true
        bool isPaid = paymentSnapshot.docs.any((paymentDoc) {
          Map<String, dynamic> paymentData =
              paymentDoc.data() as Map<String, dynamic>;
          return paymentData['paid'] == true;
        });

        data['isPaid'] = isPaid; // Add payment status to the booking data
        clientBookings.add(data);
      }

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
    final responsive = Responsive(context);

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
                  final bool isPaid = notification['isPaid'] ?? false;
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
                          ? (isPaid
                              ? 'Your appointment has been paid.'
                              : 'Your appointment has been approved. Please proceed to payment.')
                          : isDeclined
                              ? 'Your appointment was declined. Reason: $reason'
                              : 'Your appointment is still pending. Please wait for confirmation.',
                      buttonText: isApproved
                          ? (isPaid ? 'PAID' : 'Proceed to Payment')
                          : 'Close',
                      reason: isDeclined ? reason : null,
                      onPressed: isApproved && !isPaid
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
                      onDelete: isPaid
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side: Text Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (reason != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Reason: $reason',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Right Side: Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onPressed != null)
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onPressed != null
                          ? const Color(0xFF662C2B)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                if (onDelete != null)
                  TextButton(
                    onPressed: onDelete,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
