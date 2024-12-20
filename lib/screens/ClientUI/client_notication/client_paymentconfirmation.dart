import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/ClientUI/client_homepage/client_homepage.dart';

class PaymentConfirmation extends StatelessWidget {
  const PaymentConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Higala Films logo (increased size)
            Image.asset(
              'assets/images/higala_logo1.jpg', // Path to the higala_logo.png file
              width: 250, // Increased width
              height: 250, // Increased height
              fit: BoxFit
                  .contain, // Ensures the image fits properly in the space
            ),

            // Higala Films title
            const Text(
              'Higala Films',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF662C2B),
              ),
            ),
            const SizedBox(height: 20),

            // Green check icon
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80.0, // Adjust size as needed
            ),

            const SizedBox(height: 20),

            // Payment Successful message
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

            // Back to Home button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClientHomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF662C2B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
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

void main() => runApp(const MaterialApp(home: PaymentConfirmation()));
