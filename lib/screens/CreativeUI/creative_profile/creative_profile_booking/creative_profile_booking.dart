import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  String selectedCategory = "Ongoing";

  Future<void> updateTransactionStatus(String bookingId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .where('bookingId', isEqualTo: bookingId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'status': status});
        }
      });
      setState(() {}); // Force UI refresh
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction marked as $status.'),
          backgroundColor: status == 'Completed' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xFF662C2B), // Maroon background color
        title: const Text(
          'Booking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center the title in the AppBar
      ),
      body: Column(
        children: [
          // Tabs for Ongoing, Completed, Cancelled
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('Ongoing'),
                _buildCategoryButton('Completed'),
                _buildCategoryButton('Cancelled'),
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
          // Content Section
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  // Helper method to build category buttons
  Widget _buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF1E6E6)
              : Colors.grey[200], // Light color when selected
          borderRadius: BorderRadius.circular(30), // Rounded pill-like shape
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7B3A3F)
                : Colors.grey[400]!, // Outline for the selected tab
            width: 1.5,
          ),
          color: isSelected
              ? const Color(0xFF662C2B).withOpacity(0.1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF7B3A3F)
                : Colors.black54, // Darker text for the selected tab
            color: isSelected ? const Color(0xFF662C2B) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Build the transaction list dynamically based on status
  Widget _buildTransactionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('transactions')
          .where('status', isEqualTo: selectedCategory)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildNoBookings();
        }

        final transactions = snapshot.data!.docs;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction =
                transactions[index].data() as Map<String, dynamic>;
            return _buildTransactionCard(transaction);
          },
        );
      },
    );
  }

  // Method to build a transaction card
  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    return GestureDetector(
      onTap: () async {
        // Fetch additional details for the transaction
        final bookingId = transaction['bookingId'];
        final clientId = transaction['clientId'];
        final packageId = transaction['packageId'];

        // Fetch creative details
        final clientSnapshot = await FirebaseFirestore.instance
            .collection('clients')
            .doc(clientId)
            .get();
        final clientDetails = clientSnapshot.data() as Map<String, dynamic>?;

        // Fetch booking details (including event date and time)
        final bookingSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .get();
        final bookingDetails = bookingSnapshot.data() as Map<String, dynamic>?;

        // Extract event date and time from bookingDetails
        final eventDate = bookingDetails?['date'] ?? 'No event date';
        final eventTime = bookingDetails?['time'] ?? 'No event time';

        // Show dialog with transaction details
        showDialog(
          context: context,
          builder: (context) {
            print(clientDetails);
            return AlertDialog(
              title: const Text(
                'Transaction Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking ID: $bookingId'),
                    const SizedBox(height: 8),
                    Text('Package ID: $packageId'),
                    const SizedBox(height: 8),
                    Text('Client Name: ${[
                      clientDetails?['firstName'],
                      clientDetails?['lastName']
                    ].where((e) => e != null && e.isNotEmpty).join(' ').trim().isEmpty ? 'Unknown' : [
                        clientDetails?['firstName'],
                        clientDetails?['lastName']
                      ].where((e) => e != null && e.isNotEmpty).join(' ')}'),
                    const SizedBox(height: 8),
                    if (clientDetails?['profilePicture'] != null)
                      Image.network(
                        clientDetails?['profilePicture'],
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 8),
                    Text(
                        'Total Amount: ₱${transaction['totalAmount']?.toStringAsFixed(2) ?? '0.00'}'),
                    const SizedBox(height: 8),
                    Text('Paid: ${transaction['paid'] == true ? 'Yes' : 'No'}'),
                    const SizedBox(height: 8),
                    Text('Event Date: $eventDate'),
                    const SizedBox(height: 8),
                    Text('Event Time: $eventTime'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['bookingId'] ?? 'Unknown Booking ID',
                        style: const TextStyle(
                          color: Color(0xFF662C2B),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Package ID: ${transaction['packageId'] ?? 'Unknown'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Amount: ₱${transaction['totalAmount']?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectedCategory == 'Completed'
                          ? Colors.green
                          : selectedCategory == 'Cancelled'
                              ? Colors.red
                              : const Color(0xFF662C2B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      selectedCategory,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Add Complete and Cancel buttons for "Ongoing" category
              if (selectedCategory == 'Ongoing')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        updateTransactionStatus(
                            transaction['bookingId'], 'Cancelled');
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the "No Bookings" message
  Widget _buildNoBookings() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            "No Bookings",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
