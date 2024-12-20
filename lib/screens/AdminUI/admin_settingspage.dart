import 'package:example/screens/LogIn/loginscreen.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF662C2B), // Custom theme color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View Profile Details',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // Account Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.black),
                    title: const Text('Edit Profile'),
                    onTap: () {
                      // Handle Edit Profile
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.black),
                    title: const Text('Change Password'),
                    onTap: () {
                      // Handle Change Password
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.black),
                    title: const Text('Transaction History'),
                    onTap: () {
                      // Handle Transaction History
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            // System Management Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Management',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.group, color: Colors.black),
                    title: const Text('User Management'),
                    onTap: () {
                      // Handle User Management
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.flag, color: Colors.black),
                    title: const Text('Content Moderation'),
                    onTap: () {
                      // Handle Content Moderation
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.analytics, color: Colors.black),
                    title: const Text('Analytics & Insights'),
                    onTap: () {
                      // Handle Analytics & Insights
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            // More Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'More',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.black),
                    title: const Text('About us'),
                    onTap: () {
                      // Handle About Us
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.black),
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      // Handle Privacy Policy
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.article, color: Colors.black),
                    title: const Text('Terms and Conditions'),
                    onTap: () {
                      // Handle Terms and Conditions
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.help_outline, color: Colors.black),
                    title: const Text('Help'),
                    onTap: () {
                      // Handle Help
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to LoginScreen on Log Out
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (Route<dynamic> route) =>
                          false, // Clears all previous routes
                    );
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
