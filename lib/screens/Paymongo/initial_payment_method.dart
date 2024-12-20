import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Paymongo/paymongo.dart'; // Import PayMongo service
import 'package:url_launcher/url_launcher.dart';

class InitialPaymentMethod extends StatefulWidget {
  final String bookingId;

  const InitialPaymentMethod({super.key, required this.bookingId});

  @override
  State<InitialPaymentMethod> createState() => _InitialPaymentMethodState();
}

class _InitialPaymentMethodState extends State<InitialPaymentMethod> {
  Map<String, dynamic>? bookingDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  Future<void> fetchBookingDetails() async {
    try {
      final bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId)
          .get();

      if (bookingSnapshot.exists) {
        setState(() {
          bookingDetails = bookingSnapshot.data() as Map<String, dynamic>;
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
        const SnackBar(content: Text('Error fetching booking details.')),
      );
    }
  }

  Future<void> _proceedToPayMongo(double amount, String packageName) async {
    try {
      final paymentLink = await PayMongoService.createPaymentLink(
        amount: amount,
        description: packageName,
      );

      if (paymentLink != null) {
        print('Payment link created: $paymentLink');
        final canLaunchUrl = await canLaunch(paymentLink);
        if (canLaunchUrl) {
          await launch(paymentLink); // Opens the payment link in the browser
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Unable to open the payment link. Please copy and paste the link in your browser.'),
            ),
          );
          print('Payment link: $paymentLink'); // Provide fallback for the user
        }
      } else {
        print('Payment link creation failed.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create payment link.')),
        );
      }
    } catch (e) {
      print('Error in _proceedToPayMongo: $e');
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
          title: const Text('Initial Payment'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (bookingDetails == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF662C2B),
          title: const Text('Initial Payment'),
        ),
        body: const Center(child: Text('No booking details found.')),
      );
    }

    double totalCost =
        (bookingDetails?['totalCost'] as num?)?.toDouble() ?? 0.0;
    double minimumInitialPayment = totalCost * 0.2; // 20% of the total cost
    double remainingBalance = totalCost - minimumInitialPayment;
    String packageName = bookingDetails?['packageName'] ?? 'Package';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text('Initial Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Amount and Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount: ₱${totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Minimum Initial Payment (20%): ₱${minimumInitialPayment.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remaining Balance: ₱${remainingBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Initial Payment Section
            Text(
              'Initial Payment (Online Only)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _proceedToPayMongo(minimumInitialPayment, packageName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF662C2B),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Pay ₱${minimumInitialPayment.toStringAsFixed(2)} Online',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Remaining Balance Section
            Text(
              'Pay Remaining Balance (Before Due Date)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showPaymentOptions(context, remainingBalance);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payments_outlined, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Pay Remaining Balance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentOptions(BuildContext context, double remainingBalance) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Proceeding to online payment...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF662C2B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Pay Online (₱${remainingBalance.toStringAsFixed(2)})',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
