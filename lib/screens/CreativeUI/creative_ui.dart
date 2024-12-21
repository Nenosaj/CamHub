import 'package:flutter/material.dart';
import 'creative_homepage/creative_homepage.dart';
import 'creative_message/creative_userlistscreen.dart';
import 'creative_nofication/creative_nofication.dart';
import 'creative_profile/creative_profile.dart';

class CreativeUI extends StatelessWidget {
  const CreativeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CamHub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          // 'const' added here
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
        '/': (context) => const HomePage(), // 'const' added here
        '/chat': (context) => const UserListScreen(),
        '/notifications': (context) =>
            const CreativeNotificationPage(), // Define NotificationsPage in a separate file
        '/profile': (context) =>
            const CreativeProfilePage(), // Define ProfilePage in a separate file
      },
    );
  }
}
