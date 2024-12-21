import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class BugReportPage extends StatelessWidget {
  const BugReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text("Bug Report",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                hintText: "Search Bugs...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Severity Filters
            Row(
              children: [
                _buildSeverityIndicator(Colors.red, "High"),
                const SizedBox(width: 10),
                _buildSeverityIndicator(Colors.orange, "Medium"),
                const SizedBox(width: 10),
                _buildSeverityIndicator(Colors.green, "Low"),
              ],
            ),
            const SizedBox(height: 16.0),

            // Bug Cards
            Expanded(
              child: ListView(
                children: const [
                  BugCard(
                    severityColor: Colors.red,
                    title: "App Crashes on Login",
                    description:
                        "App crashes after entering login credentials.",
                    status: "Open",
                    statusColor: Colors.red,
                  ),
                  SizedBox(height: 10.0),
                  BugCard(
                    severityColor: Colors.orange,
                    title: "Slow Page Load",
                    description: "Profile page takes too long to load.",
                    status: "Pending",
                    statusColor: Colors.orange,
                  ),
                  SizedBox(height: 10.0),
                  BugCard(
                    severityColor: Colors.green,
                    title: "UI Misalignment",
                    description: "Dashboard UI breaks on smaller screens.",
                    status: "Resolved",
                    statusColor: Colors.green,
                  ),
                ],
              ),
            ),

            // Footer Summary
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("[Open: 3]",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                  Text("[Pending: 2]",
                      style: TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                  Text("[Resolved: 1]",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityIndicator(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class BugCard extends StatelessWidget {
  final Color severityColor;
  final String title;
  final String description;
  final String status;
  final Color statusColor;

  const BugCard({
    super.key,
    required this.severityColor,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final responsive = Responsive(context);

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 8, backgroundColor: severityColor),
                const SizedBox(width: 8.0),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0)),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(description, style: const TextStyle(fontSize: 14.0)),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "STATUS: $status",
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
