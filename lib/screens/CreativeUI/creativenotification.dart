import 'package:flutter/material.dart';
import 'creativenotification_card.dart';
import 'creative_notificationappointment.dart'; // Ensure proper import of the appointment page

// Mock data (which can later be integrated with backend)
const List<Map<String, dynamic>> creativeNotifications = [
  {
    "title": "Appointment Request",
    "message": "A new client has requested an appointment.",
    "time": "08:31 PM",
    "isNew": true,
  },
  {
    "title": "Appointment Request",
    "message": "A new client has requested an appointment.",
    "time": "10:00 AM",
    "isNew": false,
  },
  {
    "title": "Appointment Request",
    "message": "A new client has requested an appointment.",
    "time": "Yesterday",
    "isNew": false,
  },
];

class CreativeNotificationPage extends StatefulWidget {
  const CreativeNotificationPage({super.key});

  @override
  CreativeNotificationPageState createState() =>
      CreativeNotificationPageState();
}

class CreativeNotificationPageState extends State<CreativeNotificationPage> {
  bool _isCardVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isCardVisible = true;
      });
    });
  }

  // Function to handle dialog based on the result
  void _showActionMessage(String message) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        toolbarHeight: 80.0,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: creativeNotifications.map((notification) {
            return AnimatedSlide(
              offset: _isCardVisible ? const Offset(0, 0) : const Offset(0, 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: CreativeNotificationCard(
                title: notification['title'],
                message: notification['message'],
                time: notification['time'],
                isNew: notification['isNew'],
                // Navigate to appointment screen and handle result
                onPress: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreativeNotificationAppointment(
                        clientName: 'Client C. User',
                        contactNumber: '00000000000',
                        message: "I'd like to schedule a photo session. Please let me know your availability.",
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
            
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
