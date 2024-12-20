import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class SystemUpdatePage extends StatelessWidget {
  const SystemUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          "System Update",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: "Search Updates...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Page Title
            const Text(
              "Latest Updates",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10.0),

            // List of Updates
            Expanded(
              child: ListView(
                children: const [
                  SystemUpdateCard(
                    title: "Version 2.0.1 Released",
                    description:
                        "Bug fixes and performance improvements for the admin dashboard.",
                    timestamp: "June 10, 2024",
                  ),
                  SystemUpdateCard(
                    title: "New Feature: Approval System",
                    description:
                        "Introduced a new approval system for creatives verification.",
                    timestamp: "May 25, 2024",
                  ),
                  SystemUpdateCard(
                    title: "Security Patch v1.9.9",
                    description:
                        "Improved security measures for user authentication.",
                    timestamp: "May 5, 2024",
                  ),
                  SystemUpdateCard(
                    title: "UI Enhancement",
                    description:
                        "Updated the dashboard layout for better user experience.",
                    timestamp: "April 20, 2024",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// System Update Card Widget
class SystemUpdateCard extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;

  const SystemUpdateCard({
    super.key,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timestamp,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
