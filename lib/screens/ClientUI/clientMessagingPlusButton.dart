import 'package:flutter/material.dart';

class ClientMessagingPlusButton extends StatefulWidget {
  final Function(String) onSendMessage;

  const ClientMessagingPlusButton({Key? key, required this.onSendMessage}) : super(key: key);

  @override
  _ClientMessagingPlusButtonState createState() => _ClientMessagingPlusButtonState();
}

class _ClientMessagingPlusButtonState extends State<ClientMessagingPlusButton> {
  final TextEditingController _controller = TextEditingController();
  bool showGallery = false; // Controls whether the photo gallery is shown

  // Toggle the gallery visibility
  void _toggleGallery() {
    setState(() {
      showGallery = !showGallery;
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
        if (showGallery)
          Container(
            height: 200,
            color: Colors.grey[200],
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 4, // Number of photos (adjust as needed)
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleGallery, // Toggle the gallery view
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 194, 72, 72),
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Type Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onSubmitted: (value) {
                    _sendMessage();
                  },
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send, color: const Color.fromARGB(255, 194, 72, 72)),
                onPressed: _sendMessage, // Handle send button press
              ),
            ],
          ),
        ),
      ],
    );
  }
}

