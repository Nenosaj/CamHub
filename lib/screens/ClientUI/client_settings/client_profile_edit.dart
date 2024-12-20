import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File handling
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:example/screens/ClientUI/client_model/client_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth

class ClientProfileEdit extends StatefulWidget {
  const ClientProfileEdit({super.key});

  @override
  ClientProfileEditState createState() => ClientProfileEditState();
}

class ClientProfileEditState extends State<ClientProfileEdit> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Client? client;
  XFile? _pickedImage; // For the selected image

  @override
  void initState() {
    super.initState();
    _fetchClientData();
  }

  // Fetch client data from Firestore
  Future<void> _fetchClientData() async {
    User? currentUser =
        FirebaseAuth.instance.currentUser; // Get the current user
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Fetch client data from Firestore using uid
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('clients').doc(uid).get();

      if (userData.exists) {
        setState(() {
          client = Client.fromFirestore(userData,
              currentUser.email ?? ''); // Pass both DocumentSnapshot and email
          usernameController.text = '${client!.firstName} ${client!.lastName}';
          emailController.text = client!.email;
          dobController.text = client!.birthday;
          addressController.text =
              '${client!.street}, ${client!.city}, ${client!.province}';
          phoneController.text = client!.phoneNumber;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Storage permission is required to pick an image.')),
        );
      }
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
      // ignore: avoid_print
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  // Save changes logic (for the text fields and profile picture)
  Future<void> _saveChanges() async {
    User? currentUser =
        FirebaseAuth.instance.currentUser; // Get the current user
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Check if a new profile picture was picked
      String? profilePictureUrl;
      if (_pickedImage != null) {
        profilePictureUrl =
            await _uploadProfilePicture(uid, File(_pickedImage!.path));
      }

      // Update Firestore with the new data, including profile picture URL if available
      await FirebaseFirestore.instance.collection('clients').doc(uid).update({
        'firstName': usernameController.text.split(' ').first,
        'lastName': usernameController.text.split(' ').last,
        'phoneNumber': phoneController.text,
        'birthday': dobController.text,
        'street': addressController.text.split(',').first,
        'city': addressController.text.split(',').last,
        'profilePicture': profilePictureUrl ??
            client
                ?.profilePictureUrl, // Use the new profile picture if available, otherwise keep the old one
      });

      // Refresh the client data to update the UI with the new profile picture
      await _fetchClientData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!')),
        );
      }
    }
  }

  // Discard changes logic
  void _discardChanges() {
    setState(() {
      // Reset all fields to original values from the client model
      if (client != null) {
        usernameController.text = '${client!.firstName} ${client!.lastName}';
        emailController.text = client!.email;
        dobController.text = client!.birthday;
        addressController.text =
            '${client!.street}, ${client!.city}, ${client!.province}';
        phoneController.text = client!.phoneNumber;
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
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        title: const Text("Edit Profile"),
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Colors.white), // White arrow
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
                        : client?.profilePictureUrl != null
                            ? NetworkImage(client!.profilePictureUrl!)
                            : null, // No default image, placeholder will show
                    child: _pickedImage == null &&
                            client?.profilePictureUrl == null
                        ? const Icon(Icons.person,
                            size: 40, color: Colors.white)
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
                    controller: usernameController,
                    label: 'Username',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: emailController,
                    label: 'Email',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: dobController,
                    label: 'Date of Birth',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: addressController,
                    label: 'Address',
                  ),
                  const SizedBox(height: 16),
                  buildEditableTextField(
                    controller: phoneController,
                    label: 'Phone Number',
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
