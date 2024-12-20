import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  String selectedCategory = "Ongoing";

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final responsive = Responsive(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xFF662C2B), // Maroon background color
        title: const Text(
          'Booking Log',
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
            child: selectedCategory == "Completed"
                ? _buildCompletedBooking()
                : selectedCategory == "Cancelled"
                    ? _buildCancelledBooking()
                    : _buildNoBookings(),
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
              ? const Color(0xFF662C2B).withOpacity(0.1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? const Color(0xFF662C2B) : Colors.black,
            fontWeight: FontWeight.bold,
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

  // Method to build the "Completed" booking details
  Widget _buildCompletedBooking() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '18-05-2024',
                  style: TextStyle(
                    color: Color(0xFF662C2B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Order #4566',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '• Portrait Session',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '1:00 PM',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF662C2B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the "Cancelled" booking details
  Widget _buildCancelledBooking() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '22-06-2024',
                  style: TextStyle(
                    color: Color(0xFF7B3A3F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Order #7890',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '• Wedding Session',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '3:00 PM',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red, // Red color to indicate cancellation
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Cancelled',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
