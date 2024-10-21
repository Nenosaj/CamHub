import 'package:example/screens/CreativeUI/creative_AccountsMessaged.dart';
import 'package:example/screens/CreativeUI/creativechatbox.dart';
import 'package:flutter/material.dart';
import 'creativevidpicsmessage.dart';  // Importing the separated media grid logic

class CreativeMessagingScreen extends StatefulWidget {
  final String clientName;
  final String clientImage; // Accept client's image
  final List<Map<String, String>> existingMessages; // Accept existing messages

  const CreativeMessagingScreen({
    super.key,
    required this.clientName,
    required this.clientImage, // Add client's image as required
    required this.existingMessages,
  });

  @override
  CreativeMessagingScreenState createState() => CreativeMessagingScreenState();
}

class CreativeMessagingScreenState extends State<CreativeMessagingScreen> {
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
      for (var conversation in creativeConversationList) {
        if (conversation['clientName'] == widget.clientName) {
          conversation['messages'].add({'message': messageText, 'time': currentTime});
          found = true;
          break;
        }
      }
      if (!found) {
        // Add new conversation if it doesn't exist
        creativeConversationList.add({
          'clientName': widget.clientName,
          'clientImage': widget.clientImage, // Store the client's image
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
              backgroundImage: AssetImage(widget.clientImage), // Show the client's image
            ),
            const SizedBox(width: 12),
            Text(
              widget.clientName,
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
                return CreativeChatBox(
                    message: message['message']!, time: message['time']!);
              },
            ),
          ),
          // Integrating CreativeVidPicsMessageWidget with the send message functionality
          CreativeVidPicsMessageWidget(
            onSendMessage: _sendMessage, // Passing the callback to send message
          ),
        ],
      ),
    );
  }
}
