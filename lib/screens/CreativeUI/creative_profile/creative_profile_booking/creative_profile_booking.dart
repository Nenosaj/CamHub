import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  String selectedCategory = "Ongoing";

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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox, // Placeholder icon
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
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF7B3A3F)
                : Colors.black54, // Darker text for the selected tab
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
