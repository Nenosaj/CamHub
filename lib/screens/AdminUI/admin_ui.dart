
import 'package:example/screens/AdminUI/admin_approval/admin_approval.dart';
import 'package:example/screens/AdminUI/admin_bugreport.dart';
import 'package:example/screens/AdminUI/admin_dashboard/admin_dashboardpage.dart';
import 'package:example/screens/AdminUI/admin_systemupdate.dart';
import 'package:example/screens/AdminUI/admin_userspage.dart';
import 'package:flutter/material.dart';


class AdminUI extends StatelessWidget {
  const AdminUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CamHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme( // 'const' added here
          titleTextStyle: TextStyle(
            color: Colors.white, // Sets the title text to white
            fontSize: 20, // You can adjust the size if needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Start with the HomePage or other routes
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardPage(), // 'const' added here
        '/system_update': (context) => const SystemUpdatePage(), // Define ChatPage in a separate file
        '/bug_report': (context) => const BugReportPage(), // Define NotificationsPage in a separate file
        '/approval': (context) => const ApprovalPage(),
        '/admin_users': (context) => const AdminUsersPage(), // Define ProfilePage in a separate file
      },
    );
  }
}
