import 'package:flutter/material.dart';

// Media upload grid widget
class CreativeVidPicsMessageWidget extends StatefulWidget {
  const CreativeVidPicsMessageWidget({super.key});

  @override
  CreativeVidPicsMessageWidgetState createState() => CreativeVidPicsMessageWidgetState();
}

class CreativeVidPicsMessageWidgetState extends State<CreativeVidPicsMessageWidget> {
  bool _showMediaGrid = false; // Controls the visibility of the media grid

  // Toggle media grid visibility
  void _toggleMediaGrid() {
    setState(() {
      _showMediaGrid = !_showMediaGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Plus icon to toggle the media grid
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF662C2B), size: 28),
              onPressed: _toggleMediaGrid,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF662C2B)),
              onPressed: () {
                // Future implementation for sending messages
              },
            ),
          ],
        ),
        // Media grid that appears/disappears when the plus button is pressed
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
