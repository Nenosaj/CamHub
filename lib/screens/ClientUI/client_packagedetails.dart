import 'package:flutter/material.dart';

class PackageDetailsPage extends StatelessWidget {
  const PackageDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Package Details',
          style: TextStyle(color: Color(0xFF662C2B)),
        ),
      ),
      body: const Center(
        child: Text('Details of the selected package will be displayed here.'),
      ),
    );
  }
}
