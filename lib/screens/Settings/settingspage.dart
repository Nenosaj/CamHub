import 'package:example/screens/Firebase/authentication.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

//Client
import 'package:example/screens/ClientUI/client_model/client_model.dart';
import 'package:example/screens/ClientUI/client_profile/client_profile.dart';
import 'package:example/screens/ClientUI/client_settings/client_profile_edit.dart';

//Creative
import 'package:example/screens/CreativeUI/creative_model/creative_model.dart';
import 'package:example/screens/CreativeUI/creative_settings/creative_settings_profiledetails.dart';
import 'package:example/screens/CreativeUI/creative_settings/creative_settings_profileedit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final Authentication authController =
      Authentication(); // Initialize Authentication controller
  Client? client; // Store client info if logged in as a client
  Creative? creative; // Store creative info if logged in as a creative
  String? profilePictureUrl; // For storing the profile picture URL
  bool isClient =
      false; // Flag to determine if the user is a client or creative

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data (client or creative) when the screen is loaded
  }

  // Fetch user data based on the current user's role
  Future<void> _fetchUserData() async {
    // Fetch user UID from FirebaseAuth
    final user = authController.getCurrentUser();
    if (user != null) {
      //String uid = user.uid;

      // Try fetching client data first
      Client? fetchedClient = await Client.fetchCurrentClient();
      if (fetchedClient != null) {
        setState(() {
          isClient = true;
          client = fetchedClient;
          profilePictureUrl = client?.profilePictureUrl;
        });
      } else {
        // If no client data found, try fetching creative data
        Creative? fetchedCreative = await Creative.fetchCurrentCreative();
        if (fetchedCreative != null) {
          setState(() {
            isClient = false; // Not a client, so it's a creative
            creative = fetchedCreative;
            profilePictureUrl = creative?.profilePictureUrl;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

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
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: profilePictureUrl != null
                  ? NetworkImage(profilePictureUrl!)
                  : null, // Load the profile picture if available
              backgroundColor: Colors.grey,
              child: profilePictureUrl == null
                  ? Icon(Icons.person, color: Colors.white)
                  : null, // Show icon if no profile picture is available
            ),
            title: Text(isClient
                ? '${client?.firstName} ${client?.lastName}' // Display client info if logged in as a client
                : creative?.businessName ??
                    'Loading...'), // Display creative info if logged in as a creative
            subtitle: const Text('View Profile Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isClient
                      ? const ClientProfilePage() // Navigate to Client Profile
                      : const CreativeProfileDetails(), // Navigate to Creative Profile
                ),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isClient
                      ? const ClientProfileEdit() // Edit Client Profile
                      : const CreativeProfileEdit(), // Edit Creative Profile (you'll need to create this)
                ),
              );
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
            padding: EdgeInsets.symmetric(vertical: 8.0),
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
