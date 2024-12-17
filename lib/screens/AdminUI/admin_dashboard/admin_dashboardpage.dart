import 'package:example/screens/AdminUI/admin_approval/admin_approval.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/AdminUI/admin_dashboard/admin_analytics.dart';
import 'package:example/screens/AdminUI/admin_dashboard/admin_topcreatives.dart';
import 'package:example/screens/AdminUI/admin_settingspage.dart';
import 'package:example/screens/AdminUI/admin_bugreport.dart';
import 'package:example/screens/AdminUI/admin_systemupdate.dart';
import 'package:example/screens/AdminUI/admin_userspage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    const DashboardContent(),
    const SystemUpdatePage(), // Updated to reference SystemUpdatePage
    const BugReportPage(),    // Updated to reference BugReportPage
    const ApprovalPage(),     // Updated to reference ApprovalPage
    const AdminUsersPage(),   // Updated to reference Users Page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B),
        leading: IconButton(
          icon: const Icon(Icons.menu,
              color: Colors.white, size: 35.0), // Increased menu icon size
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminSettingsPage()), // Settings Page
            );
          },
        ),
        title: const Text(
          "CamHUB",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF7B3A3F),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.system_update), label: "System Update"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bug_report), label: "Bug Report"),
          BottomNavigationBarItem(
              icon: Icon(Icons.approval), label: "Approval"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Users"),
        ],
      ),
    );
  }
}

// Dashboard Content
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Hello, Admin!",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Analytics Section
          const DashboardAnalytics(),
          const SizedBox(height: 20.0),

          // Top-Selling Table
          const Text(
            "Top-Selling Photographer/Videographer",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          const SizedBox(height: 10.0),
          const DashboardTopCreatives(),
        ],
      ),
    );
  }
}
