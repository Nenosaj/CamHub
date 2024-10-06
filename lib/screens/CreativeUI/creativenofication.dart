import 'package:flutter/material.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF7B3A3F), // Maroon AppBar
      ),
      body: const Center(
        child: Text('Notification Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}