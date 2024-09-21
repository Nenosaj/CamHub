import 'package:flutter/material.dart';
import 'clientbookings.dart';
import 'clientnotifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Starting with the first tab (Home)

  // Different pages for each bottom navigation item
  final List<Widget> _pages = [
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    //ChatPage(), // Navigate to your Chat Page
    BookingPage(), // Navigate to your Bookings Page
    NotificationPage(), // Navigate to your Notifications Page
    //ProfilePage(), // Navigate to your Profile Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Role-Based App'),
        backgroundColor: Color(0xFF7B3A3F), // Maroon color for the AppBar
      ),
      body: _pages[_currentIndex], // Displaying the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF7B3A3F), // Maroon color for selected icon
        unselectedItemColor: Colors.grey, // Gray for unselected icons
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index on tap
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Bookings',
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
