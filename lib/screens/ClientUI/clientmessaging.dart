import 'package:flutter/material.dart';
import 'clientchatbox.dart';
//import 'clientvidpicsmessage.dart';

class MessagingScreen extends StatefulWidget {
  final String photographerName;

  const MessagingScreen({super.key, required this.photographerName});

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _showMediaGrid = false; // Controls the visibility of the media grid

  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    final messageText = _controller.text;
    final currentTime = TimeOfDay.now().format(context);

    setState(() {
      _messages.add({'message': messageText, 'time': currentTime});
    });

    _controller.clear();
  }

  // Toggle media grid visibility
  void _toggleMediaGrid() {
    setState(() {
      _showMediaGrid = !_showMediaGrid;
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
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            const SizedBox(width: 12),
            Text(
              widget.photographerName,
              style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ClientChatBox(message: message['message']!, time: message['time']!);
                  },
                ),
              ),
              // Media grid that appears/disappears when the plus button is pressed
              if (_showMediaGrid)
                Container(
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
          ),
          Positioned(
            bottom: _showMediaGrid ? 150 : 0, // Adjust based on media grid visibility
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  // Plus icon to toggle the media grid, slightly bigger
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF662C2B), size: 36),
                    onPressed: _toggleMediaGrid,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16), // Adjusted padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      style: const TextStyle(fontSize: 18), // Larger text size
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF662C2B), size: 30), // Larger send button
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
