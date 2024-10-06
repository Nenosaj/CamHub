import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePages createState() => ProfilePages();
}

class ProfilePages extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                child: Icon(Icons.person, size: 150, color: Colors.grey[600]),
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
        backgroundColor: const Color(0xFF7B3A3F), // Dark red background color
        title: const Text('Profile', style: TextStyle(color: Color.fromARGB(255, 252, 252, 252))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                      child: Icon(Icons.person, size: 55, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Photographer /Videographer',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                          Text('Location', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const Row(
                        children: [
                           Text('Rating: '),
                           Icon(Icons.star, color: Colors.orange, size: 16),
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

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  String selectedCategory = "Ongoing";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B3A3F), // Maroon color from your image
        title: Row(
          children: [
           
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white24, // Slight transparent white background
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tabs for Ongoing, Completed, Cancelled
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryButton('Ongoing'),
                _buildCategoryButton('Completed'),
                _buildCategoryButton('Cancelled'),
              ],
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),

          // Content Section
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox, // Placeholder icon
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No Bookings",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build category buttons
  Widget _buildCategoryButton(String category) {
    bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.red[100]
              : Colors.grey[200], // Highlight selected tab
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.red : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
