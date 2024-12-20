import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Paymongo/paymongo.dart'; // Import PayMongo service

class Payment extends StatefulWidget {
  final String bookingId;

  const Payment({super.key, required this.bookingId});

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  Map<String, dynamic>? bookingDetails;
  Map<String, dynamic>? creativeDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    try {
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (bookingSnapshot.exists) {
        final bookingData = bookingSnapshot.data() as Map<String, dynamic>;

        final creativeSnapshot = await FirebaseFirestore.instance
            .collection('creatives')
            .doc(bookingData['creativeId'])
            .get();

        setState(() {
          bookingDetails = bookingData;
          creativeDetails = creativeSnapshot.exists
              ? creativeSnapshot.data() as Map<String, dynamic>
              : null;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking not found.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching details.')),
      );
    }
  }

  Future<void> _createPaymentSubcollection(double totalCost) async {
    try {
      // Create a reference to the payment subcollection
      final paymentRef = FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .collection('payment');

      // Data to be added in the payment subcollection
      final paymentData = {
        'bookingId': widget.bookingId,
        'clientId': bookingDetails?['clientId'],
        'creativeId': bookingDetails?['creativeId'],
        'packageId': bookingDetails?['packageId'],
        'totalAmount': totalCost,
        'paid': false, // Default value indicating payment not yet made
        'refund': false, // Default value indicating no refund requested
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add the payment data to the Firestore subcollection
      await paymentRef.add(paymentData);

      // Notify the user about the successful creation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment initialized successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing payment: $e')),
      );
    }
  }

  Future<void> _proceedToPayMongo(double amount, String description) async {
    try {
      // Create the payment link with the remark
      final paymentLink = await PayMongoService.createPaymentLink(
        amount: amount,
        description: widget.bookingId, // Pass bookingId in the description
        remarks: '', // Include the bookingId in the remark
      );

      if (paymentLink != null) {
        final Uri url = Uri.parse(paymentLink);

        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cannot open the link: $paymentLink')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create payment link.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating payment link: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF662C2B),
          title: const Text('Payment'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (bookingDetails == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF662C2B),
          title: const Text('Payment'),
        ),
        body: const Center(child: Text('No booking details found.')),
      );
    }

    double totalCost =
        (bookingDetails?['totalCost'] as num?)?.toDouble() ?? 0.0;
    String packageName = bookingDetails?['packageName'] ?? 'Package';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        elevation: 1,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Creative Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: creativeDetails?['profilePicture'] != null
                        ? NetworkImage(creativeDetails?['profilePicture'])
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    radius: 35,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          creativeDetails?['businessName'] ??
                              'Unknown Creative',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Package: $packageName',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Booking Summary Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Package: $packageName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Total Cost: ₱${totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Create the payment subcollection in Firestore
                  await _createPaymentSubcollection(totalCost);

                  // Proceed to PayMongo with the updated remark (including bookingId)
                  await _proceedToPayMongo(totalCost, packageName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF662C2B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
