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
                // Handle Credit/Debit Card selection here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('E-Wallet'),
              onTap: () {
                // Handle E-Wallet selection here
                Navigator.pop(context);
              },
            ),
            if (!isInitialPayment) // Only show Cash option for full payment
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Cash'),
                onTap: () {
                  // Handle Cash selection here
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
