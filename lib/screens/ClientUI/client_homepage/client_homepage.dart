import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../client_message/client_userlistscreen.dart';
import '../client_booking/client_booking.dart';
import '../client_notication/client_notification.dart';
import '../client_profile/client_profile.dart';
import 'client_homepage_searchpage.dart';
import '../../Settings/settingspage.dart';
import 'client_homepage_creativedetails.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  ClientHomePageState createState() => ClientHomePageState();
}

class ClientHomePageBar extends StatelessWidget implements PreferredSizeWidget {
  const ClientHomePageBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final responsive = Responsive(context);

    return AppBar(
      backgroundColor: const Color(0xFF662C2B), // Maroon color for the AppBar
      toolbarHeight: 80.0, // Increased height for the AppBar
      leading: IconButton(
        icon: const Icon(Icons.menu,
            color: Colors.white, size: 35.0), // Increased menu icon size
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
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
      centerTitle: true, // Centers the title
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search,
              color: Colors.white, size: 35.0), // Increased search icon size
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class ClientHomePageState extends State<ClientHomePage> {
  int _currentIndex = 0; // Bottom Navigation Index
  List<Map<String, dynamic>> creatives = []; // Store fetched creatives here

  @override
  void initState() {
    super.initState();
    _fetchCreatives(); // Fetch creatives when the page loads
  }

  // Fetch creatives from Firestore directly as Map<String, dynamic>
  Future<void> _fetchCreatives() async {
    // ignore: avoid_print
    print('Fetching creatives from Firestore...');

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('creatives').get();

      List<Map<String, dynamic>> fetchedCreatives = snapshot.docs.map((doc) {
        // Add the document ID (uid) to the map
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id; // Attach the document ID as 'uid'
        return data;
      }).toList();

      setState(() {
        creatives = fetchedCreatives;
      });

      if (creatives.isEmpty) {
        // ignore: avoid_print
        print('No creatives found.');
      } else {
        // ignore: avoid_print
        print('Fetched ${creatives.length} creatives.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching creatives: $e');
    }
  }

  // List of pages for each bottom navigation item
  List<Widget> _getPages() {
    return [
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10.0), // Adjust height value as needed

            // Horizontal scrollable list for categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip("Birthdays"),
                  _buildCategoryChip("Weddings"),
                  _buildCategoryChip("Pageants"),
                  _buildCategoryChip("Graduation"),
                  _buildCategoryChip("Anniversary"),
                  _buildCategoryChip("Christening"),
                  _buildCategoryChip("Endorsement"),
                  _buildCategoryChip("Engagement"),
                ],
              ),
            ),

            const SizedBox(height: 20.0), // Spacing

            // Creatives you may like section
            _buildCreativeSection("Creatives you may like"),

            const SizedBox(height: 20.0), // Spacing

            // Popular Picks section
            _buildCreativeSection("Popular Picks"),
          ],
        ),
      ),
      const UserListScreen(), // Use default values or dynamic fetching within ChatScreen
      const BookingPage(), // Navigate to Bookings Page
      const ClientNotificationPage(), // Navigate to Notifications Page
      const ClientProfilePage(), // Navigate to Profile Page
    ];
  }

  // Creative section builder
  Widget _buildCreativeSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        creatives.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: creatives.map((creative) {
                    return _buildCreativeCard(creative);
                  }).toList(),
                ),
              )
            : const Center(
                child: Text(
                  'No creatives available.',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
              ),
      ],
    );
  }

  // Creative card builder (without Creative model, just using Firestore data)
  Widget _buildCreativeCard(Map<String, dynamic> creative) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreativesDetailPage(
              creative: creative, // Pass the creative map
            ), // Navigate to detail page
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 160.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5.0,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(
                  image: creative['profilePicture'] != null
                      ? DecorationImage(
                          image: NetworkImage(creative['profilePicture']),
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10.0)),
                ),
                child: creative['profilePicture'] == null
                    ? const Center(
                        child: Icon(Icons.person, size: 60, color: Colors.grey),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      creative['businessName'] ??
                          'Unknown Business', // Display business name
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? const ClientHomePageBar()
          : null, // Conditionally show the AppBar only on the Home page
      body: _getPages()[_currentIndex],
      backgroundColor: Colors.white, // Displaying the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor:
            const Color(0xFF7B3A3F), // Maroon color for selected icon
        unselectedItemColor: Colors.grey, // Gray for unselected icons
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index on tap
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

  // Widget for category chips
  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black, // Black text color
            fontSize: 16, // Adjust font size
          ),
        ),
        backgroundColor: Colors.grey[300], // Light grey background
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 12.0), // Padding for size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
      ),
    );
  }
}
