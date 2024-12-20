import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'client_messaging.dart'; // Import MessagingScreen for navigation

// Mock photographer data (replace this with backend/database integration)
final List<Map<String, String>> photographers = [
  {'name': 'John Doe', 'imagePath': 'assets/images/photographer1.jpg'},
  {'name': 'Jane Smith', 'imagePath': 'assets/images/photographer1.jpg'},
  {'name': 'Alice Brown', 'imagePath': 'assets/images/photographer1.jpg'},
  {'name': 'David Wilson', 'imagePath': 'assets/images/photographer1.jpg'},
  {'name': 'Emma Watson', 'imagePath': 'assets/images/photographer1.jpg'},
];

class SearchUserResults extends StatelessWidget {
  final String searchText; // Accept searchText as a parameter

  const SearchUserResults({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // Filter the photographers based on search text
    List<Map<String, String>> filteredPhotographers = photographers
        .where((photographer) => photographer['name']!
            .toLowerCase()
            .contains(searchText.toLowerCase())) // Filter based on input
        .toList();

    // If no search query is entered, show all photographers
    List<Map<String, String>> photographersToShow =
        searchText.isEmpty ? photographers : filteredPhotographers;

    return photographersToShow.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: photographersToShow.length,
            itemBuilder: (context, index) {
              final photographer = photographersToShow[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(photographer['imagePath']!),
                ),
                title: Text(photographer['name']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagingScreen(
                        photographerName: photographer['name']!,
                        photographerImage: photographer['imagePath']!,
                        existingMessages: const [],
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
