import 'package:flutter/material.dart';
import 'creativemessaging.dart'; // Import MessagingScreen for navigation

// Mock client data (replace this with backend/database integration)
final List<Map<String, String>> clients = [
  {'name': 'Client 1', 'imagePath': 'assets/images/photographer2.jpg'},
  {'name': 'Client 2', 'imagePath': 'assets/images/photographer2.jpg'},
  {'name': 'Client 3', 'imagePath': 'assets/images/photographer2.jpg'},
  {'name': 'Client 4', 'imagePath': 'assets/images/photographer2.jpg'},
  {'name': 'Client 5', 'imagePath': 'assets/images/photographer2.jpg'},
];

class CreativeSearchUserResults extends StatelessWidget {
  final String searchText; // Accept searchText as a parameter

  const CreativeSearchUserResults({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    // Filter the clients based on search text
    List<Map<String, String>> filteredClients = clients
        .where((client) => client['name']!
            .toLowerCase()
            .contains(searchText.toLowerCase())) // Filter based on input
        .toList();

    // If no search query is entered, show all clients
    List<Map<String, String>> clientsToShow =
        searchText.isEmpty ? clients : filteredClients;

    return clientsToShow.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: clientsToShow.length,
            itemBuilder: (context, index) {
              final client = clientsToShow[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(client['imagePath']!),
                ),
                title: Text(client['name']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreativeMessagingScreen(
                        clientName: client['name']!,
                        clientImage: client['imagePath']!,
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
    return clients
        .where((client) => client['name']!
            .toLowerCase()
            .contains(searchText.toLowerCase())) // Filter based on input
        .toList()
        .length;
  }
}
