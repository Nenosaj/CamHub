import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

class DashboardAnalytics extends StatefulWidget {
  const DashboardAnalytics({super.key});

  @override
  State<DashboardAnalytics> createState() => _DashboardAnalyticsState();
}

class _DashboardAnalyticsState extends State<DashboardAnalytics> {
  int _existingUsers = 0; // Variable to store user count

  @override
  void initState() {
    super.initState();
    _fetchExistingUsers();
  }

  // Fetch user count from Firestore
  Future<void> _fetchExistingUsers() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _existingUsers = usersSnapshot.docs.length;
      });
    } catch (e) {
      print("Error fetching user count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildStatCard(
                  "0", // Static placeholder for Total Revenue
                  "Total Revenue",
                  Icons.monetization_on,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildStatCard(
                  "0", // Static placeholder for Total Impressions
                  "Total Impressions",
                  Icons.remove_red_eye,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildStatCard(
                  "0", // Static placeholder for New Users
                  "New Users",
                  Icons.person_add,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _buildStatCard(
                  _existingUsers.toString(), // Display fetched user count
                  "Existing Users",
                  Icons.people,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(icon, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
