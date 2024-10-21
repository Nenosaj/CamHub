import 'package:flutter/material.dart';
import 'clientmessaging.dart'; // Import the messaging screen

// Mock photographer data (replace with backend/database integration)
final List<Map<String, String>> photographers = [
  {'name': 'John Doe', 'imagePath': 'assets/images/photographer1.jpg'},
  {'name': 'Jane Smith', 'imagePath': 'assets/images/photographer2.jpg'},
  {'name': 'Alice Brown', 'imagePath': 'assets/images/photographer3.jpg'},
  {'name': 'David Wilson', 'imagePath': 'assets/images/photographer4.jpg'},
  {'name': 'Emma Watson', 'imagePath': 'assets/images/photographer5.jpg'},
];

class SearchUserResults extends StatelessWidget {
  final String searchText; // Accept searchText as a parameter

  const SearchUserResults({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    // Filter the photographers based on search text
    List<Map<String, String>> filteredPhotographers = photographers
        .where((photographer) => photographer['name']!
            .toLowerCase()
            .contains(searchText.toLowerCase())) // Filter based on input
        .toList();

    return filteredPhotographers.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Add padding
            itemCount: filteredPhotographers.length,
            itemBuilder: (context, index) {
              final photographer = filteredPhotographers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(photographer['imagePath']!), // Use image from list
                ),
                title: Text(photographer['name']!), // Display photographer's name
                onTap: () {
                  // Navigate to the clientmessaging.dart page when a name is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagingScreen(
                        photographerName: photographer['name']!, // Pass the photographer's name to the chat screen
                      ),
                    ),
                  );
                },
              );
            },
          );
  }

  // Helper function to return the number of results
  int getResultsCount() {
    return photographers
        .where((photographer) => photographer['name']!
            .toLowerCase()
            .contains(searchText.toLowerCase())) // Filter based on input
        .toList()
        .length;
  }
}
