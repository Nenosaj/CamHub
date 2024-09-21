import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF7B3A3F), // Dark red color from the image
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement back navigation
          },
        ),
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            color: Color(0xFF7B3A3F),
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Account Settings',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          // Account Settings Section
          buildSettingsOption(
            context: context,
            icon: Icons.edit,
            text: 'Edit profile',
            onTap: () {
              // Implement Edit profile navigation
            },
          ),
          buildSettingsOption(
            context: context,
            icon: Icons.lock,
            text: 'Change password',
            onTap: () {
              // Implement Change password navigation
            },
          ),
          buildSettingsOption(
            context: context,
            icon: Icons.history,
            text: 'Transaction History',
            onTap: () {
              // Implement Transaction History navigation
            },
          ),
          Divider(),
          // More Section
          buildSettingsOption(
            context: context,
            icon: Icons.info,
            text: 'About us',
            onTap: () {
              // Implement About us navigation
            },
          ),
          buildSettingsOption(
            context: context,
            icon: Icons.privacy_tip,
            text: 'Privacy policy',
            onTap: () {
              // Implement Privacy policy navigation
            },
          ),
          buildSettingsOption(
            context: context,
            icon: Icons.description,
            text: 'Terms and conditions',
            onTap: () {
              // Implement Terms and conditions navigation
            },
          ),
          buildSettingsOption(
            context: context,
            icon: Icons.help,
            text: 'Help',
            onTap: () {
              // Implement Help navigation
            },
          ),
        ],
      ),
    );
  }

  // Function to build a pressable ListTile option
  Widget buildSettingsOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Function onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF7B3A3F)),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onTap(),
    );
  }
}
