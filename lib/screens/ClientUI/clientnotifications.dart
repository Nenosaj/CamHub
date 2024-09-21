import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B3A3F), // Maroon color from your image
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded search bar
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Colors.grey[200], // Light gray background for search bar
              ),
            ),
          ),
          const Spacer(), // Pushes the empty state to the center

          // Empty state icon and message
          const Column(
            children: [
              Icon(
                Icons
                    .hourglass_empty, // Replace ghost with hourglass_empty icon
                size: 100, // Similar size to the image you showed
                color: Colors.black54, // Neutral color for the icon
              ),
              SizedBox(height: 16),
              Text(
                "There's nothing here",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54), // Same text as in the image
              ),
            ],
          ),

          const Spacer(), // Pushes content upwards
        ],
      ),
    );
  }
}
