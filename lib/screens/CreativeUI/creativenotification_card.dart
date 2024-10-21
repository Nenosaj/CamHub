import 'package:flutter/material.dart';

class CreativeNotificationCard extends StatefulWidget {
  final String title;
  final String message;
  final String time;
  final bool isNew; // Added flag to mark new notifications

  const CreativeNotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    this.isNew = false, // Default is not new
  });

  @override
  _CreativeNotificationCardState createState() => _CreativeNotificationCardState();
}

class _CreativeNotificationCardState extends State<CreativeNotificationCard> {
  late bool _isSeen; // Track whether the notification has been pressed

  @override
  void initState() {
    super.initState();
    _isSeen = !widget.isNew; // If it's new, it's not seen; if not new, it's already seen
  }

  void _handlePress() {
    setState(() {
      _isSeen = true; // Mark the notification as seen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: _handlePress, // Handle press event
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: _isSeen ? Colors.white : const Color.fromARGB(255, 218, 200, 200), // Dark grey for new, white for seen
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
