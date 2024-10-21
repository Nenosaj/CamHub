import 'package:example/screens/ClientUI/client_AccountsMessaged.dart';
import 'package:flutter/material.dart';
import 'clientchatbox.dart';
import 'clientvidpicsmessage.dart';  // Importing the separated media grid logic

class MessagingScreen extends StatefulWidget {
  final String photographerName;
  final String photographerImage; // Accept photographer's image
  final List<Map<String, String>> existingMessages; // Accept existing messages

  const MessagingScreen({
    super.key,
    required this.photographerName,
    required this.photographerImage, // Add photographer image as required
    required this.existingMessages,
  });

  @override
  MessagingScreenState createState() => MessagingScreenState();
}

class MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<Map<String, String>> _messages; // List of messages

  @override
  void initState() {
    super.initState();
    _messages = widget.existingMessages; // Initialize with existing messages
  }

  void _sendMessage(String messageText) {
    if (messageText.isEmpty) return; // Make sure there's text to send

    final currentTime = TimeOfDay.now().format(context);

    setState(() {
      _messages.add({'message': messageText, 'time': currentTime});

      // Update the conversation list or add a new entry
      bool found = false;
      for (var conversation in conversationList) {
        if (conversation['photographerName'] == widget.photographerName) {
          conversation['messages'].add({'message': messageText, 'time': currentTime});
          found = true;
          break;
        }
      }
      if (!found) {
        // Add new conversation if it doesn't exist
        conversationList.add({
          'photographerName': widget.photographerName,
          'photographerImage': widget.photographerImage, // Store the photographer's image
          'messages': [{'message': messageText, 'time': currentTime}],
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B), size: 28),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(widget.photographerImage), // Show the photographer's image
            ),
            const SizedBox(width: 12),
            Text(
              widget.photographerName,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ClientChatBox(
                    message: message['message']!, time: message['time']!);
              },
            ),
          ),
          // Integrating VidPicsMessageWidget with the send message functionality
          VidPicsMessageWidget(
            onSendMessage: _sendMessage, // Passing the callback to send message
          ),
        ],
      ),
    );
  }
}
