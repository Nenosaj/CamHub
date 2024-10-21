import 'creativemessage.dart';
import 'creativenofication.dart';
import 'package:flutter/material.dart';
import '../settingspage.dart';
import 'creativeprofile.dart';
import 'creativeanalytics.dart';
import 'creativeuploadbutton.dart';

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
        creativeName: 'Higala Films',
        rating: 4.3,
        monthlyRevenue: 48500,
        totalOrders: 1200,
        totalCustomers: 850,
        totalImpressions: 26000,
      ),
      const CreativeChatScreen(
        clientName: '',
        messages: [],
      ), // Navigate to your Chat Page
      const CreativeUploadButton(),
      const CreativeNotificationPage(), // Navigate to your Notifications Page
      const ProfilePage(), // Navigate to your Profile Page
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
