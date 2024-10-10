import 'package:flutter/material.dart';
import 'clientchatbox.dart'; // Import the chat box widget
import 'clientMessagingPlusButton.dart'; // Import the plus button widget
import 'package:intl/intl.dart'; // For formatting time

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  List<Map<String, String>> messages = []; // List to hold the chat messages and time

  void _addMessage(String message) {
    final String currentTime = DateFormat('hh:mm a').format(DateTime.now());
    setState(() {
      messages.add({'message': message, 'time': currentTime});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 80, // Increase the height of the AppBar for better visibility
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 253, 253, 253), size: 28), // Bigger back button for easier tapping
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 24, // Make the avatar slightly larger
              backgroundImage: AssetImage('assets/profile_image.png'), // Replace with actual image
            ),
            SizedBox(width: 12),
            Text(
              'Creative',
              style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold), // Larger text
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ClientChatBox(
                  message: messages[index]['message']!,
                  time: messages[index]['time']!,
                );
              },
            ),
          ),
          Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ClientMessagingPlusButton(
              onSendMessage: _addMessage,
            ),
          ),
        ],
      ),
    );
  }
}
