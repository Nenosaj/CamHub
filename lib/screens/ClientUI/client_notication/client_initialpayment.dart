/*import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'client_paymentconfirmation.dart';
import 'client_paymentselection.dart';

class InitialPayment extends StatefulWidget {
  final Map<String, bool> selectedAddOns;
  final Map<String, String> addOnPrices;
  final int totalCost;

  const InitialPayment({
    super.key,
    required this.selectedAddOns,
    required this.addOnPrices,
    required this.totalCost,
  });

  @override
  InitialPaymentState createState() => InitialPaymentState();
}

class InitialPaymentState extends State<InitialPayment> {
  String?
      _selectedInitialPaymentMethod; // Store selected initial payment method
  String? _selectedFullPaymentMethod; // Store selected full payment method

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // Calculate the downpayment (20% of the total cost)
    final double downPayment = widget.totalCost * 0.2;

    // Calculate the remaining amount (Total - Downpayment)
    final double remainingAmount = widget.totalCost - downPayment;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Initial Payment',
          style: TextStyle(color: Color(0xFF662C2B)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Higala Films section
            Row(
              children: [
                Image.asset(
                  'assets/images/higala_logo.png', // Use your logo asset here
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Higala Films',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(), // Divider between Higala Films and Selection Summary
            const SizedBox(height: 10),

            // Selection Summary section
            const Text(
              'Selection Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                children: [
                  const TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Package 1'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('₱5,000'),
                    ),
                  ]),
                  ...widget.selectedAddOns.entries.map((entry) {
                    if (entry.value) {
                      return TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(entry.key),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.addOnPrices[entry.key] ?? '₱...'),
                        ),
                      ]);
                    }
                    return const TableRow(children: [SizedBox(), SizedBox()]);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Total section
            Text(
              'Total: ₱${widget.totalCost}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(), // Divider between Total and Payment Methods
            const SizedBox(height: 10),

            // Initial Payment Method section with Wallet Icon
            const Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Initial Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    // Handle Initial Payment Method selection here
                    final selectedMethod = await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) => const PaymentMethodSelection(
                        isInitialPayment: true,
                      ),
                      isScrollControlled:
                          true, // Enable scrolling in the bottom sheet
                    );

                    // Update the selected initial payment method
                    if (selectedMethod != null) {
                      setState(() {
                        _selectedInitialPaymentMethod = selectedMethod;
                      });
                    }
                  },
                  child: Text(
                    _selectedInitialPaymentMethod ?? 'Select Initial Method',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF662C2B),
                      decoration: TextDecoration.underline,
                      fontWeight: _selectedInitialPaymentMethod != null
                          ? FontWeight.bold // Make the text bold when selected
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Text(
                  '₱${downPayment.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ), // Assuming 20% of the total payment
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              '*for initial payment the clients must pay 20% of the total payment',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),

            // Full Payment Method section with Money Icon
            const Row(
              children: [
                Icon(Icons.attach_money, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  'Full Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    // Handle Full Payment Method selection here
                    final selectedMethod = await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) => const PaymentMethodSelection(
                        isInitialPayment: false,
                      ),
                      isScrollControlled:
                          true, // Enable scrolling in the bottom sheet
                    );

                    // Update the selected full payment method
                    if (selectedMethod != null) {
                      setState(() {
                        _selectedFullPaymentMethod = selectedMethod;
                      });
                    }
                  },
                  child: Text(
                    _selectedFullPaymentMethod ?? 'Select Payment Method',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF662C2B),
                      decoration: TextDecoration.underline,
                      fontWeight: _selectedFullPaymentMethod != null
                          ? FontWeight.bold // Make the text bold when selected
                          : FontWeight.normal,
                    ),
                  ),
                ),
                // Display the remaining amount (Total - Downpayment)
                Text(
                  '₱${remainingAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Divider(), // Divider before CONFIRM button
            const SizedBox(height: 40),

            // CONFIRM Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentConfirmation(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF662C2B), // Button background color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 130,
                    vertical: 15,
                  ), // Adjust padding to center text properly
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2, // Slight elevation for a lifted effect
                ),
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 16,
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
*/