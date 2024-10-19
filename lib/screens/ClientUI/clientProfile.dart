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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Implement back navigation logic
          },
        ),
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
                  decoration: BoxDecoration(
                    color: const Color(0xFF662C2B),
                    borderRadius: const BorderRadius.vertical(
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
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 80, color: Colors.grey[600]),
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
                    hint: '09##-###-####',
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

  Widget buildTextField({
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
            fontWeight: FontWeight.bold, // Make the label bold
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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