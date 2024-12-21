import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class ApprovalReviewPage extends StatelessWidget {
  const ApprovalReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Approval Request Review",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Information
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 12.0),
                const Text(
                  "Higala Films",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Business Information
            const Text(
              "Business Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            _buildInfoRow(Icons.business, "Higala Films"),
            const SizedBox(height: 5.0),
            _buildInfoRow(Icons.location_on,
                "Santa Cruz I, Lapasan\nCagayan de Oro, Misamis Oriental, Philippines"),
            const SizedBox(height: 5.0),
            _buildInfoRow(Icons.email, "higala.films@gmail.com"),
            const SizedBox(height: 5.0),
            _buildInfoRow(Icons.phone, "091600008975"),

            const SizedBox(height: 80.0),

            // Proof of Documents
            const Text(
              "Proof of Business Documents",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            _buildDocumentRow(context, "file.pdf"),
            _buildDocumentRow(context, "bir.pdf"),
            _buildDocumentRow(context, "ITR.png"),

            const Spacer(),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black54),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentRow(BuildContext context, String fileName) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: const Icon(Icons.insert_drive_file, color: Colors.black54),
        title: Text(fileName),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 95, 95, 95)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Previewing $fileName")),
            );
          },
          child: const Text("Preview", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Request Confirmed")),
              );
              Navigator.pop(context);
            },
            child: const Text("CONFIRM", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Request Declined")),
              );
              Navigator.pop(context);
            },
            child: const Text("DECLINE", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
