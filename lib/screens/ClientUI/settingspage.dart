import 'package:flutter/material.dart';
//import 'package:example/screens/loginscreen.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF662C2B), // Maroon color
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back when pressed
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // User Info Section
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text('Name'),
            subtitle: Text('View Profile'),
            onTap: () {
              // Navigate to Profile or Edit Profile
            },
          ),
          Divider(),
          // Account Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Account Settings',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              // Navigate to Edit Profile
            },
          ),
          // New Change Password Option
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              // Navigate to Change Password screen
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Transaction History'),
            onTap: () {
              // Navigate to Transaction History
            },
          ),
          Divider(),
          // More Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'More',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () {
              // Navigate to About us
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Terms and Conditions'),
            onTap: () {
              // Navigate to Terms and Conditions
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help'),
            onTap: () {
              // Navigate to Help
            },
          ),
          SizedBox(height: 50), // Spacer to push the logout option down
          ListTile(
            title: TextButton(
              onPressed: () {
                // Handle logout
              },
              child: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
