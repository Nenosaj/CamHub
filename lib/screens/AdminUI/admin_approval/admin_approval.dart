import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/AdminUI/admin_approval/approval_review.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          "User Approval",
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
                hintText: "Search",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Approval Requests List
            Expanded(
              child: ListView(
                children: [
                  ApprovalCard(
                    title: "Creative Approval Request",
                    description:
                        "A new creative has requested an approval and verification.",
                    timestamp: "08:31 PM",
                    onTap: () => _navigateToReview(context),
                  ),
                  const SizedBox(height: 10.0),
                  ApprovalCard(
                    title: "Creative Approval Request",
                    description:
                        "A new creative has requested an approval and verification.",
                    timestamp: "10:00 AM",
                    onTap: () => _navigateToReview(context),
                  ),
                  const SizedBox(height: 10.0),
                  ApprovalCard(
                    title: "Creative Approval Request",
                    description:
                        "A new creative has requested an approval and verification.",
                    timestamp: "Yesterday",
                    onTap: () => _navigateToReview(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to ApprovalReviewPage
  void _navigateToReview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApprovalReviewPage(),
      ),
    );
  }
}

class ApprovalCard extends StatelessWidget {
  final String title;
  final String description;
  final String timestamp;
  final VoidCallback onTap;

  const ApprovalCard({
    super.key,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Redirect on press
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              Text(
                timestamp,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
