import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers to capture input data from the user
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7B3A3F), // Dark red color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile image placeholder
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF7B3A3F), // Matching the dark red color
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Input fields
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildTextField(
                    controller: usernameController,
                    label: 'Username',
                    hint: 'name123',
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'name@mail.com',
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: dobController,
                    label: 'Date of Birth',
                    hint: 'MM/DD/YYYY',
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: '123 Street, City',
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    hint: '09123456789',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a text field with a hint
  Widget buildTextField(
      {required TextEditingController controller,
      required String label,
      required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint, // Placeholder text inside the field
        border: const OutlineInputBorder(),
      ),
    );
  }
}
