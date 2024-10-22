import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File handling
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:example/screens/CreativeUI/creative_model.dart'; // Use the Creative model
import 'package:permission_handler/permission_handler.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreativeProfileEdit(),
    );
  }
}

class CreativeProfileEdit extends StatefulWidget {
  const CreativeProfileEdit({super.key});

  @override
  CreativeProfileEditState createState() => CreativeProfileEditState();
}

class CreativeProfileEditState extends State<CreativeProfileEdit> {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Creative? creative; // Creative model
  XFile? _pickedImage; // For the selected image

  @override
  void initState() {
    super.initState();
    _fetchCreativeData();
  }

  // Fetch creative data from Firestore
  Future<void> _fetchCreativeData() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Fetch creative data from Firestore using uid
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('creatives').doc(uid).get();

      if (userData.exists) {
        setState(() {
          creative = Creative.fromFirestore(userData, currentUser.email ?? ''); // Pass both DocumentSnapshot and email
          businessNameController.text = creative!.businessName;
          businessEmailController.text = creative!.businessEmail;
          phoneController.text = creative!.businessPhoneNumber;
          addressController.text =
              '${creative!.street}, ${creative!.city}, ${creative!.province}';
        });
      }
    }
  }

  // Pick image for profile picture
  Future<void> _pickImage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage = image;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required to pick an image.')),
      );
    }
  }

  // Upload profile picture to Firebase Storage and get the download URL
  Future<String?> _uploadProfilePicture(String uid, File imageFile) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profilePictures/$uid.jpg');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  // Save changes logic (for the text fields and profile picture)
  Future<void> _saveChanges() async {
    User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Check if a new profile picture was picked
      String? profilePictureUrl;
      if (_pickedImage != null) {
        profilePictureUrl = await _uploadProfilePicture(uid, File(_pickedImage!.path));
      }

      // Update Firestore with the new data, including profile picture URL if available
      await FirebaseFirestore.instance.collection('creatives').doc(uid).update({
        'businessName': businessNameController.text,
        'businessEmail': businessEmailController.text,
        'businessPhoneNumber': phoneController.text,
        'street': addressController.text.split(',').first,
        'city': addressController.text.split(',')[1],
        'province': addressController.text.split(',').last,
        'profilePicture': profilePictureUrl ?? creative?.profilePictureUrl, // Use the new profile picture if available, otherwise keep the old one
      });

      // Refresh the creative data to update the UI with the new profile picture
      await _fetchCreativeData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
    }
  }

  // Discard changes logic
  void _discardChanges() {
    setState(() {
      // Reset all fields to original values from the creative model
      if (creative != null) {
        businessNameController.text = creative!.businessName;
        businessEmailController.text = creative!.businessEmail;
        phoneController.text = creative!.businessPhoneNumber;
        addressController.text = '${creative!.street}, ${creative!.city}, ${creative!.province}';
      }
      // Reset picked image
      _pickedImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes discarded.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text("Edit Profile"),
        elevation: 0,
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white), // White arrow
    onPressed: () {
      Navigator.of(context).pop(); // Action to go back
    },
  ),
        actions: [
          // Save Changes button
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              "Save Changes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile image with edit option
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
                  onTap: _pickImage,
                  child: CircleAvatar(
                      radius: 80,
                      backgroundImage: _pickedImage != null
                          ? FileImage(File(_pickedImage!.path))
                          : creative?.profilePictureUrl != null
                              ? NetworkImage(creative!.profilePictureUrl!)
                              : null, // No default image, placeholder will show
                      child: _pickedImage == null && creative?.profilePictureUrl == null
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Input fields
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildEditableTextField(
                    controller: businessNameController,
                    label: 'Business Name',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: businessEmailController,
                    label: 'Business Email',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: phoneController,
                    label: 'Business Phone Number',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: addressController,
                    label: 'Address',
                  ),
                  const SizedBox(height: 30),
                  // Discard Changes button
                  Center(
                    child: ElevatedButton(
                      onPressed: _discardChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Discard Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for editable text fields
  Widget buildEditableTextField({
    required TextEditingController controller,
    required String label,
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
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
