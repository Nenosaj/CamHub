import 'package:flutter/material.dart';
import 'package:example/screens/authentication.dart'; 
//import 'package:example/screens/loadingstate.dart';



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final Authentication authController = Authentication(); // Initialize Authentication controller

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B), // Maroon color
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back when pressed
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Info Section
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Name'),
            subtitle: const Text('View Profile'),
            onTap: () {
              // Navigate to Profile or Edit Profile
            },
          ),
          const Divider(),
          // Account Settings Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Account Settings',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              // Navigate to Edit Profile
            },
          ),
          // New Change Password Option
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              // Navigate to Change Password screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Transaction History'),
            onTap: () {
              // Navigate to Transaction History
            },
          ),
          const Divider(),
          // More Section
          const Padding(
            padding:  EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'More',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About us'),
            onTap: () {
              // Navigate to About us
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Terms and Conditions'),
            onTap: () {
              // Navigate to Terms and Conditions
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help'),
            onTap: () {
              // Navigate to Help
            },
          ),
          const SizedBox(height: 50), // Spacer to push the logout option down
          ListTile(
            title: TextButton(
              onPressed: () async {
                // Call signOut method from Authentication class

                await authController.signOut(context);
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
