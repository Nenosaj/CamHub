import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/FilePicker/filepicker.dart'; // Assuming filepicker.dart is here

class ApprovalReviewPage extends StatelessWidget {
  final String creativeId; // ID of the creative user in Firebase
  final List<Map<String, dynamic>> uploadedFiles;

  const ApprovalReviewPage({
    super.key,
    required this.creativeId,
    required this.uploadedFiles,
  });

  Future<Map<String, dynamic>> _fetchBusinessInfo() async {
    final doc = await FirebaseFirestore.instance
        .collection('creatives')
        .doc(creativeId)
        .get();
    if (doc.exists) {
      return doc.data() ?? {};
    } else {
      throw Exception("Creative data not found");
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchBusinessInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No business information found"));
          }

          final businessInfo = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      businessInfo['businessName'] ?? "Unknown Business",
                      style: const TextStyle(
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
                _buildInfoRow(Icons.business,
                    businessInfo['businessName'] ?? "Unknown Business"),
                const SizedBox(height: 5.0),
                _buildInfoRow(Icons.location_on,
                    businessInfo['businessAddress'] ?? "Unknown Address"),
                const SizedBox(height: 5.0),
                _buildInfoRow(Icons.email,
                    businessInfo['businessEmail'] ?? "Unknown Email"),
                const SizedBox(height: 5.0),
                _buildInfoRow(Icons.phone,
                    businessInfo['businessPhone'] ?? "Unknown Phone"),

                const SizedBox(height: 20.0),

                const Text(
                  "Proof of Business Documents",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 10.0),

                Expanded(
                  child: ListView.builder(
                    itemCount: uploadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = uploadedFiles[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: const Icon(Icons.insert_drive_file,
                              color: Colors.black54),
                          title: Text(file['fileName']),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 95, 95, 95),
                            ),
                            onPressed: () =>
                                _previewFile(context, file['filePath']),
                            child: const Text("Preview",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () => _processApplication(context, true),
                        child: const Text("CONFIRM",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => _processApplication(context, false),
                        child: const Text("DECLINE",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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

  void _previewFile(BuildContext context, String filePath) {
    FilePickerUtils.openFile(
        filePath); // Assuming FilePickerUtils handles file previews
  }

  void _processApplication(BuildContext context, bool isApproved) async {
    final message = isApproved ? "Request Confirmed" : "Request Declined";

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) Navigator.pop(context);
    }
  }
}

class FilePickerUtils {
  static void openFile(String filePath) {
    // Logic to open a file
    print('Opening file at: $filePath');
  }
}
