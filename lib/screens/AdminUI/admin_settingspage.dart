import 'package:example/screens/SignIn/loginscreen.dart';
import 'package:flutter/material.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B), // Maroon background color
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white, // Ensures contrast for AppBar title
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set a white background for the page
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Header
              ListTile(
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                title: const Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: const Text('View Profile Details'),
                onTap: () {
                  // Navigate to Profile Details Page
                },
              ),
              const Divider(),
              // Account Settings Section
              _buildSectionTitle('Account Settings'),
              _buildSettingsTile(
                context,
                icon: Icons.edit,
                title: 'Edit Profile',
                onTap: () {
                  // Navigate to Edit Profile Page
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.lock,
                title: 'Change Password',
                onTap: () {
                  // Navigate to Change Password Page
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.history,
                title: 'Transaction History',
                onTap: () {
                  // Navigate to Transaction History Page
                },
              ),
              const Divider(),
              // More Section
              _buildSectionTitle('More'),
              _buildSettingsTile(
                context,
                icon: Icons.info,
                title: 'About us',
                onTap: () {
                  // Navigate to About Us Page
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                onTap: () {
                  // Navigate to Privacy Policy Page
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.article,
                title: 'Terms and Conditions',
                onTap: () {
                  // Navigate to Terms and Conditions Page
                },
              ),
              _buildSettingsTile(
                context,
                icon: Icons.help,
                title: 'Help',
                onTap: () {
                  // Navigate to Help Page
                },
              ),
              const SizedBox(height: 20),
              // Log Out Button
              TextButton(
                onPressed: () {
                  // Navigate to LoginScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to create section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  // Helper to create settings tiles
  Widget _buildSettingsTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap,
    );
  }
}
