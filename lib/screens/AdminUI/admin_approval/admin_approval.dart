import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'approval_review.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text(
          "User Approval",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('creatives').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending approvals found"));
          }

          final creatives = snapshot.data!.docs;

          return ListView.builder(
            itemCount: creatives.length,
            itemBuilder: (context, index) {
              final creative = creatives[index];
              final creativeId = creative.id;
              final creativeData = creative.data() as Map<String, dynamic>;
              final businessName =
                  creativeData['businessName'] ?? "Unknown Business";
              final businessEmail =
                  creativeData['businessEmail'] ?? "No Email Provided";

              return ApprovalCard(
                title: businessName,
                description: businessEmail,
                onTap: () => _navigateToReview(context, creativeId),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _navigateToReview(
      BuildContext context, String creativeId) async {
    try {
      final creativeDoc = await FirebaseFirestore.instance
          .collection('creatives')
          .doc(creativeId)
          .get();

      final uploadedFiles =
          creativeDoc.data()?['uploadedFiles'] as List<dynamic>? ?? [];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ApprovalReviewPage(
            creativeId: creativeId,
            uploadedFiles: uploadedFiles
                .map((file) => {
                      "fileName": file["fileName"] ?? "Unnamed File",
                      "filePath": file["filePath"] ?? "",
                    })
                .toList(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}

class ApprovalCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const ApprovalCard({
    super.key,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
      ),
    );
  }
}
