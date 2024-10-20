import 'creativemessage.dart';
import 'creativenofication.dart';
import 'package:flutter/material.dart';
import '../settingspage.dart';
import 'creativeprofile.dart';
import 'creativeanalytics.dart'; // Import Creative Analytics

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
  Size get preferredSize =>
      const Size.fromHeight(80.0); // Define the height of the AppBar
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Add the CreativeAnalytics as a part of the pages
  List<Widget> _getPages() {
    return [
      const CreativeAnalytics(
        // Add Creative Analytics here as the first page
        creativeName: 'Higala Films',
        rating: 4.3,
        monthlyRevenue: 48500,
        totalOrders: 1200,
        totalCustomers: 850,
        totalImpressions: 26000,
      ),
      const CreativeChatScreen(), // Navigate to your Chat Page
      const CreativeNotificationPage(), // Navigate to your Notifications Page
      const ProfilePage(), // Navigate to your Profile Page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? const HomeAppBar()
          : null, // Conditionally show the AppBar only on the Home page
      body: _getPages()[_currentIndex], // Displaying the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex >= 2
            ? _currentIndex + 1
            : _currentIndex, // Adjust to skip index 2 (FAB)
        selectedItemColor:
            const Color(0xFF7B3A3F), // Maroon color for selected icon
        unselectedItemColor: Colors.grey, // Gray for unselected icons
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            if (index == 2) {
              // Do nothing for the floating action button
              return;
            }
            // Skip index 2 (the floating action button), shift indices after that by 1
            _currentIndex = index > 2 ? index - 1 : index;
          });
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
            icon: SizedBox.shrink(), // Placeholder for FAB
            label: '',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Your action here
        },
        backgroundColor: Colors.transparent,
        child: Container(
          width: 56.0, // Width and height of the circular white background
          height: 56.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // White circle background
          ),
          child: const Icon(
            Icons.add, // "+" icon
            color: Color(0xFF7B3A3F), // Maroon color for the "+" icon
            size: 30.0, // Adjust the size if needed
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
