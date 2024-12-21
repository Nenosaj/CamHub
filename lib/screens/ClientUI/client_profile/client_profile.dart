import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/ClientUI/client_model/client_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClientProfilePage(),
    );
  }
}

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ClientProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // This will store the current client information
  Client? client;

  @override
  void initState() {
    super.initState();
    _fetchClientData(); // Fetch client data when the screen is loaded
  }

  // Fetch client data from the database
  Future<void> _fetchClientData() async {
    Client? fetchedClient = await Client.fetchCurrentClient();
    if (fetchedClient != null) {
      setState(() {
        client = fetchedClient;
        // Set the controllers to display the fetched data
        usernameController.text = '${client!.firstName} ${client!.lastName}';
        emailController.text = client!.email; // Assuming phone is the email
        dobController.text = client!.birthday;
        addressController.text =
            '${client!.street}, ${client!.city}, ${client!.province}';
        phoneController.text = client!.phoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        elevation: 0,
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
                    backgroundImage: client?.profilePictureUrl != null
                        ? NetworkImage(client!.profilePictureUrl!)
                        : null, // Load from URL if available
                    backgroundColor: Colors.grey[300],
                    child: client?.profilePictureUrl == null
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
                    controller: usernameController,
                    label: 'Username',
                    hint: 'name123',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'name@mail.com',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
                    controller: dobController,
                    label: 'Date of Birth',
                    hint: 'MM/DD/YYYY',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
                    controller: addressController,
                    label: 'Address',
                    hint: '123 Street, City',
                  ),
                  const SizedBox(height: 16),
                  buildReadOnlyTextField(
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
