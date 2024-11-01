import 'package:flutter/material.dart';

class PaymentMethodSelection extends StatelessWidget {
  final bool isInitialPayment;

  const PaymentMethodSelection({
    super.key,
    required this.isInitialPayment, // Pass whether it's for initial payment
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit/Debit Card'),
              onTap: () {
                // Return the selected payment method
                Navigator.pop(context, 'Credit/Debit Card');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('G-Cash'),
              onTap: () {
                // Return the selected payment method
                Navigator.pop(context, 'G-Cash');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Maya'),
              onTap: () {
                // Return the selected payment method
                Navigator.pop(context, 'Maya');
              },
            ),
            if (!isInitialPayment) // Only show Cash option for full payment
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Cash'),
                onTap: () {
                  // Return the selected payment method
                  Navigator.pop(context, 'Cash');
                },
              ),
          ],
        ),
      ),
    );
  }
}
