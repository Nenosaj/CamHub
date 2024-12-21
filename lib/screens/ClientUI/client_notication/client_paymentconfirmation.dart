import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/ClientUI/client_homepage/client_homepage.dart';

class PaymentConfirmation extends StatefulWidget {
  final String bookingId;

  const PaymentConfirmation({super.key, required this.bookingId});

  @override
  _PaymentConfirmationState createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation> {
  String? creativeName;
  String? profilePicture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCreativeDetails();
  }

  Future<void> fetchCreativeDetails() async {
    try {
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (bookingSnapshot.exists) {
        final bookingData = bookingSnapshot.data() as Map<String, dynamic>;
        final creativeId = bookingData['creativeId'];

        final creativeSnapshot = await FirebaseFirestore.instance
            .collection('creatives')
            .doc(creativeId)
            .get();

        if (creativeSnapshot.exists) {
          final creativeData = creativeSnapshot.data() as Map<String, dynamic>;
          setState(() {
            creativeName = creativeData['businessName'];
            profilePicture = creativeData['profilePicture'];
            isLoading = false;
          });
        } else {
          throw Exception('Creative not found.');
        }
      } else {
        throw Exception('Booking not found.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching creative details: $e')),
      );
    }
  }

  Future<void> createTransaction() async {
    try {
      // Fetch booking details
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (bookingSnapshot.exists) {
        final bookingData = bookingSnapshot.data() as Map<String, dynamic>;

        // Fetch payment details from the `payment` subcollection
        final paymentSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.bookingId)
            .collection('payment')
            .get();

        List<Map<String, dynamic>> paymentDetails = [];

        for (var paymentDoc in paymentSnapshot.docs) {
          final paymentData = paymentDoc.data();
          paymentDetails.add({
            'referenceNumber': paymentData['referenceNumber'],
            'paymentLink': paymentData['paymentLink'],
            'totalAmount': paymentData['totalAmount'],
            'paid': paymentData['paid'],
            'refund': paymentData['refund'],
          });
        }

        // Create a new transaction document in Firestore
        await FirebaseFirestore.instance.collection('transactions').add({
          'bookingId': widget.bookingId,
          'clientId': bookingData['clientId'],
          'creativeId': bookingData['creativeId'],
          'packageId': bookingData['packageId'],
          'totalAmount': bookingData['totalCost'],
          'paymentDetails': paymentDetails, // Add payment details
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction successfully created.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (profilePicture != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePicture!),
                      radius: 60,
                    ),
                  const SizedBox(height: 20),
                  if (creativeName != null)
                    Text(
                      creativeName!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF662C2B),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80.0,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'PAYMENT SUCCESSFUL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF662C2B),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Thank you for choosing Higala Films!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF662C2B),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      await createTransaction(); // Create the transaction
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientHomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF662C2B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
