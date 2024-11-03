import 'package:flutter/material.dart';
import 'package:example/screens/CreativeUI/creative_model/creative_model.dart'; // Import Creative model
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreativeProfileDetails(),
    );
  }
}

class CreativeProfileDetails extends StatefulWidget {
  const CreativeProfileDetails({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<CreativeProfileDetails> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // This will store the current creative information
  Creative? creative;

  @override
  void initState() {
    super.initState();
    _fetchCreativeData(); // Fetch creative data when the screen is loaded
  }

  // Fetch creative data from the database
  Future<void> _fetchCreativeData() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Get the current signed-in user
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Fetch creative data from Firestore using uid
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('creatives').doc(uid).get();

      if (userData.exists) {
        setState(() {
          creative = Creative.fromFirestore(userData, currentUser.email ?? ''); // Pass the document snapshot and email
          // Set the controllers to display the fetched data
          businessNameController.text = creative!.businessName;
          businessEmailController.text = creative!.businessEmail;
          businessPhoneController.text = creative!.businessPhoneNumber;
          addressController.text =
              '${creative!.street}, ${creative!.city}, ${creative!.province}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        elevation: 0,
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white), // White arrow
    onPressed: () {
      Navigator.of(context).pop(); // Action to go back
    },
  ),
      
        // Removed the leading property to get rid of the white arrow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile image placeholder with curved background
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF662C2B),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(160),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showProfileImage(context);
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: creative?.profilePictureUrl != null
                        ? NetworkImage(creative!.profilePictureUrl!)
                        : null, // Load from URL if available
                    backgroundColor: Colors.grey[300],
                    child: creative?.profilePictureUrl == null
                        ? Icon(Icons.person, size: 80, color: Colors.grey[600])
                        : null, // Show icon if no profile picture is available
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Input fields (read-only)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildReadOnlyTextField(
                    controller: businessNameController,
                    label: 'Business Name',
                    hint: 'Business Name',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
                    controller: businessEmailController,
                    label: 'Business Email',
                    hint: 'business@mail.com',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
                    controller: businessPhoneController,
                    label: 'Business Phone Number',
                    hint: '09##-###-####',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: '123 Street, City, Province',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to display the profile image in a larger view
  void _showProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 150, color: Colors.grey[600]),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget for read-only text fields
  Widget buildReadOnlyTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true, // Set the field to read-only
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black87),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
