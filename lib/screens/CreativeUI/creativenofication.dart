import 'package:flutter/material.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF7B3A3F), // Maroon AppBar
      ),
      body: Center(
        child: Text('Notification Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}