import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:example/screens/ClientUI/client_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClientProfileEdit(),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _fetchClientData();
  }

  // Fetch client data from Firestore
  Future<void> _fetchClientData() async {
    Client? fetchedClient = await Client.fetchCurrentClient();
    if (fetchedClient != null) {
      setState(() {
        client = fetchedClient;
        usernameController.text = '${client!.firstName} ${client!.lastName}';
        emailController.text = client!.phoneNumber; // Assuming phone is email
        dobController.text = client!.birthday;
        addressController.text = '${client!.street}, ${client!.city}';
        phoneController.text = client!.phoneNumber;
      });
    }
  }

  // Save changes logic (for the text fields)
  Future<void> _saveChanges() async {
    if (client != null) {
      // Update Firestore with the new data from the text fields
      await FirebaseFirestore.instance.collection('clients').doc(client!.uid).update({
        'firstName': usernameController.text.split(' ').first,
        'lastName': usernameController.text.split(' ').last,
        'phoneNumber': emailController.text, // Assuming phone is email
        'birthday': dobController.text,
        'street': addressController.text.split(',').first,
        'city': addressController.text.split(',').last,
        'phoneNumber': phoneController.text,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully!')),
    );
  }

  // Discard changes logic
  void _discardChanges() {
    setState(() {
      // Reset all fields to original values from the client model
      if (client != null) {
        usernameController.text = '${client!.firstName} ${client!.lastName}';
        emailController.text = client!.phoneNumber;
        dobController.text = client!.birthday;
        addressController.text = '${client!.street}, ${client!.city}';
        phoneController.text = client!.phoneNumber;
      }
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
