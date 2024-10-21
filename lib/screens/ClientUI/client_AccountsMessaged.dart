import 'package:flutter/material.dart';
import 'clientmessaging.dart'; // Import MessagingScreen for navigation

// Declare conversationList globally to store the conversations and messages
List<Map<String, dynamic>> conversationList = []; // Now holds photographerName, messages, and photographerImage

class ClientAccountsMessaged extends StatelessWidget {
  const ClientAccountsMessaged({super.key});

  @override
  Widget build(BuildContext context) {
    return conversationList.isEmpty
        ? const EmptyChatScreen() // Show "No messages" when empty
        : ListView.builder(
            itemCount: conversationList.length,
            itemBuilder: (context, index) {
              final conversation = conversationList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Rounded corners for rectangle shape
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Subtle shadow effect
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 24, // Keep profile picture size consistent
                      backgroundImage: AssetImage(conversation['photographerImage']), // Display the photographer's image
                    ),
                    title: Text(
                      conversation['photographerName']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      conversation['messages'].last['message']!,
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      conversation['messages'].last['time']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      // Navigate back to MessagingScreen with existing messages and profile image when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagingScreen(
                            photographerName: conversation['photographerName']!,
                            photographerImage: conversation['photographerImage'], // Pass the image
                            existingMessages: _getExistingMessages(conversation['photographerName']!), // Pass the existing messages
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
  }

  // Function to get existing messages for a specific photographer
  List<Map<String, String>> _getExistingMessages(String photographerName) {
    // Search for existing messages in the conversationList
    for (var conversation in conversationList) {
      if (conversation['photographerName'] == photographerName) {
        return List<Map<String, String>>.from(conversation['messages']);
      }
    }
    return []; // Return empty if no previous messages
  }
}

class EmptyChatScreen extends StatelessWidget {
  const EmptyChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'No Messages',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
