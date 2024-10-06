import 'package:flutter/material.dart';


class PhotographerDetailPage extends StatelessWidget {
  const PhotographerDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photographer Details'),
      ),
      body: const Center(
        child: Text('Details about the selected photographer go here.'),
      ),
    );
  }
}