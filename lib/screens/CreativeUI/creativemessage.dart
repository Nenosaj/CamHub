import 'package:flutter/material.dart';
import 'creativechatbox.dart'; // Import the chat box widget for Creative
import 'creativeMessagingPlusButton.dart'; // Import the plus button widget for Creative
import 'package:intl/intl.dart'; // For formatting time

class CreativeMessagingScreen extends StatefulWidget {
  const CreativeMessagingScreen({super.key});

  @override
  _CreativeMessagingScreenState createState() => _CreativeMessagingScreenState();
}

class _CreativeMessagingScreenState extends State<CreativeMessagingScreen> {
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
          icon: Icon(Icons.arrow_back, color: const Color(0xFF662C2B), size: 28), // Bigger back button
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
              'Client', // Change this label based on your need
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
                return CreativeChatBox(
                  message: messages[index]['message']!,
                  time: messages[index]['time']!,
                );
              },
            ),
          ),
          Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: CreativeMessagingPlusButton(
              onSendMessage: _addMessage,
            ),
          ),
        ],
      ),
    );
  }
}
