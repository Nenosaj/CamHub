import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Paymongo/paymongo.dart'; // Import PayMongo service
import 'package:example/screens/ClientUI/client_notication/client_paymentconfirmation.dart';

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

        final paymentSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.bookingId)
            .collection('payment')
            .get();

        setState(() {
          bookingDetails = bookingData;
          creativeDetails = creativeSnapshot.exists
              ? creativeSnapshot.data() as Map<String, dynamic>
              : null;

          // Check each payment in the subcollection
          for (final doc in paymentSnapshot.docs) {
            final paymentData = doc.data();
            if (!(paymentData['paid'] as bool)) {
              updatePaymentStatus(paymentData['referenceNumber']);
            }
          }

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

  Future<void> updatePaymentStatus(String referenceNumber) async {
    try {
      // Fetch payment details from PayMongo using the reference number
      print(referenceNumber);
      final paymentDetails =
          await PayMongoService.fetchLinkByReferenceNumber(referenceNumber);

      print(paymentDetails);

      if (paymentDetails != null) {
        final isPaid = paymentDetails['status'] == 'paid';

        // Update the `paid` status in Firestore
        final paymentRef = FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.bookingId)
            .collection('payment');

        // Find the payment document with the matching `referenceNumber`
        final querySnapshot = await paymentRef
            .where('referenceNumber', isEqualTo: referenceNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final paymentDoc = querySnapshot.docs.first;

          // Update the `paid` status in Firestore
          await paymentDoc.reference.update({
            'paid': isPaid,
          });

          print(isPaid);

          if (isPaid) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment marked as paid.')),
            );
            // Check if all payments are paid
            await checkIfAllPaymentsArePaid();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment is still pending.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment document not found.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch payment details.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating payment status: $e')),
      );
    }
  }

  Future<void> checkIfAllPaymentsArePaid() async {
    try {
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .collection('payment')
          .get();

      // Check if all payments have `paid` set to `true`
      final allPaid = paymentSnapshot.docs.every((doc) {
        final paymentData = doc.data();
        return paymentData['paid'] == true;
      });

      if (allPaid) {
        // Show thank-you dialog
        await navigateToConfirmationScreen();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking payment status: $e')),
      );
    }
  }

  Future<void> _refreshDetails() async {
    setState(() {
      isLoading = true; // Show the loading indicator
    });

    await fetchDetails(); // Reload the booking and payment details
  }

  Future<void> navigateToConfirmationScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmation(bookingId: widget.bookingId),
      ),
    );
  }

  Future<void> _createPaymentSubcollection(
      double totalCost, String referenceNumber, String paymentLink) async {
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
        'referenceNumber':
            referenceNumber, // Save the extracted reference number
        'paymentLink': paymentLink, // Save the generated payment link
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
      // Check if there is already a payment link for this booking
      final paymentSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .collection('payment')
          .get();

      if (paymentSnapshot.docs.isNotEmpty) {
        for (var doc in paymentSnapshot.docs) {
          final paymentData = doc.data();
          if (paymentData['referenceNumber'] != null) {
            // If a reference number already exists, reuse the link
            final existingLink = paymentData['paymentLink'];
            final referenceNumber = paymentData['referenceNumber'];

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reusing existing payment link.')),
            );

            // Open the existing payment link
            final Uri url = Uri.parse(existingLink);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cannot open the link: $existingLink')),
              );
            }
            return; // Exit the method since we're reusing the link
          }
        }
      }

      // If no payment link exists, create a new one
      final paymentLink = await PayMongoService.createPaymentLink(
        amount: amount,
        description: widget.bookingId,
        remarks: '', // Include any remark if needed
      );

      if (paymentLink != null) {
        final referenceNumber = extractReferenceFromLink(paymentLink);

        // Save the new payment link in Firestore
        await _createPaymentSubcollection(amount, referenceNumber, paymentLink);

        // Open the new payment link
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
        SnackBar(content: Text('Error handling payment link: $e')),
      );
    }
  }

  String extractReferenceFromLink(String link) {
    try {
      final uri = Uri.parse(link);
      // Split the path into segments and extract the last segment
      final segments = uri.pathSegments;
      return segments.isNotEmpty ? segments.last : '';
    } catch (e) {
      print('Error extracting reference from link: $e');
      return '';
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF662C2B),
          onPressed: _refreshDetails, // Call the refresh function
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF662C2B),
        onPressed: _refreshDetails, // Call the refresh function
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
