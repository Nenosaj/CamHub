import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'creative_bookingprofile.dart';
import 'creative_model.dart'; // Import the creative model

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreativeProfilePage(),
    );
  }
}

class CreativeProfilePage extends StatefulWidget {
  const CreativeProfilePage({super.key});

  @override
  ProfilePages createState() => ProfilePages();
}

class ProfilePages extends State<CreativeProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Creative? creative; // Store the fetched creative data

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchCreativeData(); // Fetch creative data on init
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch the currently signed-in creative
  Future<void> _fetchCreativeData() async {
    try {
      // Get the current signed-in user from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      String businessEmail = FirebaseAuth.instance.currentUser!.email!;


      if (user != null) {
        // Fetch creative's data from Firestore
        DocumentSnapshot creativeDoc = await FirebaseFirestore.instance
            .collection('creatives')
            .doc(user.uid)
            .get();

        if (creativeDoc.exists) {
          setState(() {
            creative = Creative.fromFirestore(creativeDoc, businessEmail);
          });
        } else {
          print("No creative data found.");
        }
      }
    } catch (e) {
      print("Error fetching creative data: $e");
    }
  }

  void _enlargeProfileImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the enlarged image when tapped
            },
            child: Center(
              child: CircleAvatar(
                radius: 150, // Larger radius for the profile image
                backgroundColor: Colors.grey[300],
                backgroundImage: creative?.profilePictureUrl != null
                    ? NetworkImage(creative!.profilePictureUrl!)
                    : null,
                child: creative?.profilePictureUrl == null
                    ? Icon(Icons.person, size: 150, color: Colors.grey[600])
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        backgroundColor: const Color(0xFF662C2B), // Dark red background color
        title: const Text('Profile', style: TextStyle(color: Color.fromARGB(255, 252, 252, 252))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.transparent, // Set the color to white
),
          onPressed: () {
            // Implement back navigation if necessary
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Info Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _enlargeProfileImage(context); // Enlarge the profile image when tapped
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: creative?.profilePictureUrl != null
                          ? NetworkImage(creative!.profilePictureUrl!)
                          : null,
                      child: creative?.profilePictureUrl == null
                          ? Icon(Icons.person, size: 55, color: Colors.grey[600])
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creative?.businessName ?? 'Business Name',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        creative?.city ?? 'Location',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                          Text(creative?.city ?? 'Location', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Rating: '),
                          Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(creative?.rating.toString() ?? '0.0'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bookings Button (half width and aligned left)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3, // Half width of the screen
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to BookingPage when the button is pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B3A3F), // Dark red color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8), // Adjust button height
                      ),
                      child: const Text(
                        "Bookings",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Tab Bar (Photos, Videos, Packages, Review)
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF7B3A3F),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF7B3A3F),
              tabs: const [
                Tab(text: 'Photos'),
                Tab(text: 'Videos'),
                Tab(text: 'Packages'),
                Tab(text: 'Review'),
              ],
            ),
            // Tab View
            SizedBox(
              height: 300, // Set height for the TabBarView
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Photos Tab: Display "No Photos Uploaded" Icon
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No photos uploaded',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  // Videos Tab: Add similar placeholder logic
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No videos uploaded',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  // Packages Tab
                  Center(
                    child: Text(
                      'No packages available',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
                  // Review Tab
                  Center(
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
