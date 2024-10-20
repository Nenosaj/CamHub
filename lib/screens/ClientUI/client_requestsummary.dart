import 'package:example/screens/ClientUI/client_bookingconfirmation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting

class RequestSummary extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String address;
  final Map<String, bool> selectedAddOns;
  final Map<String, String> addOnPrices; // Map of add-on prices
  final int totalCost;
  final String eventType;

  const RequestSummary({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.selectedAddOns,
    required this.addOnPrices, // Pass the add-on prices map
    required this.totalCost,
    required this.eventType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Review Request',
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
                  ...selectedAddOns.entries.map((entry) {
                    if (entry.value) {
                      return TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(entry.key),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(addOnPrices[entry.key] ?? '₱...'),
                        ),
                      ]);
                    }
                    return const TableRow(children: [SizedBox(), SizedBox()]);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Event details section
            Row(
              children: [
                const Icon(Icons.event_note),
                const SizedBox(width: 10),
                Text(
                  eventType,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.event),
                const SizedBox(width: 10),
                Text(
                  DateFormat.yMMMMd().format(selectedDate),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(selectedTime.format(context)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 10),
                Text(address),
              ],
            ),

            const SizedBox(height: 20),

            // Total section
            Text(
              'Total: ₱$totalCost',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Divider(), // Divider between Total and Contact Information
            const SizedBox(height: 10),

            // Contact Information section
            const Text(
              'Your Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Full Name field with label above
            const Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),

            const SizedBox(height: 10),

            // Phone Number field with label above
            const Text(
              'Phone Number (optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),

            const SizedBox(height: 10),
            // Add Notes field with label above
            const Text(
              'Add notes (optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 255, 255, 255),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors
                  .grey.shade200, // Light background color for the container
              child: Column(
                children: [
                  const Text(
                    "The information you provided will be shared with Higala Films as a message so they can contact you. Furthermore, it is subject to their terms and policies, as well as CAMHUB's Data Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, // Adjust font size as needed
                      color: Color(0xFF662C2B),
                      fontStyle: FontStyle.italic, // Match the text color
                    ),
                  ),
                  const SizedBox(
                      height:
                          10), // Add some spacing between the text and the button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  const BookingConfirmation(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF662C2B), // Button background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical:
                                15), // Adjust padding to center text properly
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30), // More rectangular shape
                        ),
                        elevation: 2, // Slight elevation for a lifted effect
                      ),
                      child: const Text(
                        'REQUEST APPOINTMENT',
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
          ],
        ),
      ),
    );
  }
}
