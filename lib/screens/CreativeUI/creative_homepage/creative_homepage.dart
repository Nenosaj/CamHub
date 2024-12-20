import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/screens/CreativeUI/creative_model/creative_model.dart';
import '../creative_message/creative_message.dart';
import '../creative_nofication/creative_nofication.dart';
import '../../Settings/settingspage.dart';
import '../creative_profile/creative_profile.dart';
import 'creative_analytics.dart';
import '../creative_upload/creative_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF662C2B), // Maroon color for the AppBar
      toolbarHeight: 80.0, // Increased height for the AppBar
      leading: IconButton(
        icon: const Icon(Icons.menu,
            color: Colors.white, size: 35.0), // Increased menu icon size
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SettingsPage()), // New route
          );
        },
      ),
      title: const Text(
        'CamHUB',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0, // Increased font size for title
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Creative? currentCreative; // Store the fetched creative here
  int totalBookings = 0; // Total booking count

  @override
  void initState() {
    super.initState();
    _fetchCurrentCreative(); // Fetch the currently signed-in creative
  }

  // Fetch the current creative
  Future<void> _fetchCurrentCreative() async {
    try {
      Creative? fetchedCreative = await Creative.fetchCurrentCreative();
      if (fetchedCreative != null) {
        setState(() {
          currentCreative = fetchedCreative; // Store the creative data
        });
      } else {
        // ignore: avoid_print
        print('No creative found for the current user.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching current creative: $e');
    }
  }

  Future<void> _fetchTotalBookings({required String creativeId}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(creativeId)
          .collection('uploads')
          .get();

      setState(() {
        totalBookings = snapshot.docs.length; // Count documents
      });

      print("Total Bookings: $totalBookings");
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }

  // List of pages for each bottom navigation item
  List<Widget> _getPages() {
    if (currentCreative == null) {
      return [
        const Center(
            child:
                CircularProgressIndicator()), // Show loading until creative is fetched
      ];
    }

    // Once the creative is fetched, return the list of pages
    return [
      CreativeAnalytics(
        creativeName: currentCreative!.businessName,
        rating: currentCreative!.rating,
        monthlyRevenue: 0, // Placeholder for now; you will update this later
        totalOrders: totalBookings, // Placeholder for now
        totalCustomers: 0, // Placeholder for now
        totalImpressions: 0, // Placeholder for now
      ),
      CreativeChatScreen(
        clientName: '',
        messages: [], // Placeholder for messages
      ),
      const CreativeUploadButton(), // Add button
      const CreativeNotificationPage(), // Navigate to your Notifications Page
      const CreativeProfilePage(), // Navigate to your Profile Page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? const HomeAppBar() : null,
      body: _getPages()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF7B3A3F),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 2) {
            showDialog(
              context: context,
              builder: (BuildContext context) => const CreativeUploadButton(),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 35.0), // Add icon integrated
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
