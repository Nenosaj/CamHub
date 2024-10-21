import 'package:flutter/material.dart';
import 'creative_notificationappointment.dart';

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
  CreativeNotificationCardState createState() =>
      CreativeNotificationCardState();
}

class CreativeNotificationCardState extends State<CreativeNotificationCard> {
  late bool _isSeen; // Track whether the notification has been pressed

  @override
  void initState() {
    super.initState();
    _isSeen = !widget
        .isNew; // If it's new, it's not seen; if not new, it's already seen
  }

  void _handlePress() {
    setState(() {
      _isSeen = true; // Mark the notification as seen
    });
    // Navigate to the appointment screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreativeNotificationAppointment(
          clientName: 'Client C. User',
          contactNumber: '00000000000',
          message:
              "I'd like to schedule a photo session. Please let me know your availability.",
          eventTitle: 'Debut',
          eventDate: 'Fri, Dec 31, 2025',
          eventTime: '12:00 PM - 3:30 PM',
          eventLocation: 'Lumbia, Cagayan de Oro, Philippines',
          packageName: 'Package 1',
          services: [
            'Drone Shot',
            '5 more pictures',
            '1-minute video',
            '2-minutes video',
            '3-minutes video',
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: InkWell(
        onTap: _handlePress,
        splashColor: Colors.grey.withOpacity(0.2), // Splash effect color
        highlightColor:
            Colors.grey.withOpacity(0.1), // Highlight effect color when pressed
        borderRadius:
            BorderRadius.circular(12), // To match the card's border radius
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isSeen ? Colors.white : Colors.white, // White when pressed
            boxShadow: [
              if (_isSeen)
                BoxShadow(
                  color:
                      Colors.grey.withOpacity(0.3), // Subtle shadow after press
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
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
