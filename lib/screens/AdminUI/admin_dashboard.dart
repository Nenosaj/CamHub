import 'package:flutter/material.dart';
import 'package:example/screens/AdminUI/admin_dashboardpage.dart';
import 'package:example/screens/AdminUI/admin_systemupdate.dart';
import 'admin_bugreport.dart';
import 'admin_approval.dart';
import 'admin_userspage.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  AdminDashboardState createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  List<Widget> _getPages() {
    return [
      const DashboardPage(),
      const SystemUpdatePage(),
      const BugReportPage(),
      const ApprovalPage(),
      const UsersPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF662C2B), // Maroon color for the AppBar
        toolbarHeight: 80.0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 35.0),
          onPressed: () {
            // Implement menu navigation
          },
        ),
        title: const Text(
          'CamHUB',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to Admin Profile
            },
          ),
        ],
      ),
      body: _getPages()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF7B3A3F),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.system_update),
            label: 'System Update',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            label: 'Bug Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approval',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}
