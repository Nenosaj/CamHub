import 'package:example/screens/CreativeUI/creative_message/creative_messagingplusbutton.dart';
import 'package:flutter/material.dart';

class CreativeVidPicsMessageWidget extends StatefulWidget {
  final Function(String) onSendMessage; // Accept a callback for sending a message

  const CreativeVidPicsMessageWidget({super.key, required this.onSendMessage});

  @override
  CreativeVidPicsMessageWidgetState createState() => CreativeVidPicsMessageWidgetState();
}

class CreativeVidPicsMessageWidgetState extends State<CreativeVidPicsMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _showMediaGrid = false; // Controls media grid visibility

  // Toggle the media grid visibility
  void _toggleGallery() {
    setState(() {
      _showMediaGrid = !_showMediaGrid; // Toggle the gallery visibility
    });
  }

  // Send the message
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSendMessage(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 10), // Added padding
          child: Row(
            children: [
              // Plus button is now coming from ClientMessagingPlusButton.dart
              CreativeMessagingPlusButton(onPermissionGranted: _toggleGallery), // Use the plus button here
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16), // Adjusted padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 18), // Larger text size
                  onSubmitted: (value) {
                    _sendMessage(); // Send the message when 'Enter' is pressed
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF662C2B), size: 30),
                onPressed: _sendMessage, // Send the message when the button is pressed
              ),
            ],
          ),
        ),
        if (_showMediaGrid)
          SizedBox(
            height: 150, // Adjust the height based on the grid size
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 4, // Placeholder for 4 pictures
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 50,
                  ), // Placeholder for images
                );
              },
            ),
          ),
      ],
    );
  }
}
