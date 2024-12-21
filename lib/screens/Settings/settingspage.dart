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

import 'package:example/screens/Settings/transactionhistory.dart';

import 'package:example/screens/SignUp/setpassword.dart';

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
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data (client or creative) when the screen is loaded
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  // Fetch user data based on the current user's role
  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = authController.getCurrentUser();
      if (user != null) {
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
    } finally {
      setState(() {
        isLoading = false;
      });
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
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
                            : const CreativeProfileEdit(), // Edit Creative Profile
                      ),
                    );
                  },
                ),
                // New Change Password Option
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Set Password'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetPassword(
                            email:
                                authController.getCurrentUser()?.email ?? ''),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Transaction History'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TransactionHistory(isClient: isClient),
                      ),
                    );
                  },
                ),

                const Divider(),
                // More Section
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'More',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About us'),
                  onTap: () {
                    _showDialog(
                      context,
                      'About Us',
                      'CamHub is a client-centric platform that connects clients with creatives for seamless collaboration. We are dedicated to fostering creativity and building lasting relationships through our services.',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    _showDialog(
                      context,
                      'Privacy Policy',
                      '''*Effective Date:* [December 19, 2024]

*Introduction*  
Welcome to CamHUB! Your privacy is important to us, and we are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile app.

*Information We Collect*  
1. *Personal Information*: When you register or book services, we may collect personal details such as your name, email address, phone number, and payment information.  
2. *Service Details*: Information about the services you book, including the date, location, and other specifics.  
3. *Usage Data*: We collect data about how you interact with the app, such as pages visited, features used, and device information.  
4. *Location Data*: If you permit, we collect location information for accurate service matching.

*How We Use Your Information*  
- To facilitate bookings between users and service providers.  
- To process payments securely.  
- To enhance user experience through personalized features and recommendations.  
- To provide customer support and address inquiries.  
- To comply with legal and regulatory requirements.

*Sharing Your Information*  
We do not sell or rent your personal information. However, we may share your data with:  
- Service providers to facilitate bookings.  
- Payment processors for secure transactions.  
- Legal authorities if required by law.

*Data Security*  
We use industry-standard security measures to protect your personal information. However, no method of data transmission or storage is 100% secure, and we cannot guarantee absolute security.

*Your Rights*  
You have the right to access, update, or delete your personal information. Contact us at [Insert Email Address] for assistance.

*Changes to this Privacy Policy*  
We may update this Privacy Policy from time to time. Any changes will be posted on this page, and your continued use of the app signifies acceptance of the updated policy.''',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Terms and Conditions'),
                  onTap: () {
                    _showDialog(
                      context,
                      'Terms and Conditions',
                      '''*Effective Date:* [Insert Date]

*Introduction*  
Welcome to CamHUB! These Terms and Conditions govern your use of the CamHUB mobile application. By using the app, you agree to these terms.

*1. User Accounts*  
- Users must provide accurate and up-to-date information during registration.  
- You are responsible for maintaining the confidentiality of your account credentials.

*2. Service Booking*  
- CamHUB acts as a platform connecting users with photographers and videographers.  
- All bookings must be made through the app to ensure proper tracking and payment.

*3. Payment Terms*  
- CamHUB collects a 20% commission on all payments made through the app.  
- Payments are processed securely via [Insert Payment Gateway].  
- Refunds, if applicable, are subject to the service provider's cancellation policy.

*4. User Responsibilities*  
- Users must respect the terms set by service providers.  
- Any disputes between users and service providers must be resolved independently of CamHUB.

*5. Prohibited Activities*  
- Misuse of the platform for illegal activities.  
- Sharing false information or engaging in fraudulent transactions.

*6. Limitation of Liability*  
CamHUB is not liable for any disputes, losses, or damages arising from the use of services booked through the app.

*7. Termination*  
We reserve the right to suspend or terminate accounts violating these Terms and Conditions.

*8. Changes to Terms*  
We may modify these Terms and Conditions at any time. Continued use of the app constitutes acceptance of the updated terms.

*Contact Us*  
For questions or concerns, please contact us at [Insert Email Address].

By using CamHUB, you agree to these Terms and Conditions. Thank you for choosing our platform!''',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help'),
                  onTap: () {
                    _showDialog(
                      context,
                      'Help',
                      'Need assistance? Visit our Help Center or contact our support team for guidance on using CamHub.',
                    );
                  },
                ),

                const SizedBox(
                    height: 50), // Spacer to push the logout option down
                ListTile(
                  title: TextButton(
                    onPressed: () async {
                      // Call signOut method from Authentication class
                      await authController.signOut(context);
                    },
                    child: const Text('Log Out',
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
    );
  }
}
