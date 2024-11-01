import 'package:flutter/material.dart';

class CreativeReviews extends StatelessWidget {
  const CreativeReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(color: Color(0xFF662C2B)),
        ),
      ),
      body: const Center(
        child: Text('Details of the Client Reviews will be displayed here.'),
      ),
    );
  }
}
