import 'package:flutter/material.dart';
import 'clientmessage.dart';
import 'clientbookings.dart';
import 'clientnotifications.dart';
import 'clientProfile.dart';
import 'clienthomepage_searchpage.dart';
import 'settingspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF662C2B), // Maroon color for the AppBar
      toolbarHeight: 80.0, // Increased height for the AppBar
      leading: IconButton(
        icon: Icon(Icons.menu,
            color: Colors.white, size: 35.0), // Increased menu icon size
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsPage()), // New route
          ).then((result) {
            // Handle any result returned when the SearchPage is popped
            if (result != null) {
              // Do something with the result (if needed)
            }
          });
        },
      ),
      title: Text(
        'CamHUB',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0, // Increased font size for title
        ),
      ),
      centerTitle: true, // Centers the title
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search,
              color: Colors.white, size: 35.0), // Increased search icon size
          onPressed: () {
            // Push the SearchPage route onto the stack
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchPage()), // New route
            ).then((result) {
              // Handle any result returned when the SearchPage is popped
              if (result != null) {
                // Do something with the result (if needed)
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(80.0); // Define the height of the AppBar
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Starting with the first tab (Home)

  // List of pages for each bottom navigation item
  List<Widget> _getPages() {
    return [
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0), // Adjust height value as needed

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

            // Spacing between categories and photographer cards
            SizedBox(height: 20.0),

            // Photographers/Cinematographers you may like
            _buildPhotographerSection(
                "Photographers/Cinematographers you may like"),

            // Spacing between sections
            SizedBox(height: 20.0),

            // Popular Picks
            _buildPhotographerSection("Popular Picks"),
          ],
        ),
      ),
      ChatScreen(), // Navigate to your Chat Page
      BookingPage(), // Navigate to your Bookings Page
      NotificationPage(), // Navigate to your Notifications Page
      ProfilePage(), // Navigate to your Profile Page
    ];
  }

  // Photographer/Cinematographer section builder
  Widget _buildPhotographerSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) => _buildPhotographerCard()),
          ),
        ),
      ],
    );
  }

  // Photographer/Cinematographer card builder
  Widget _buildPhotographerCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PhotographerDetailPage()), // Navigate to detail page
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
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Replace with your actual image
              Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/photographer1.jpg'), // Replace with the actual image asset
                    fit: BoxFit.cover,
                  ),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Photographer/Cinematographer",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.0),
                    Text("★★★★★",
                        style: TextStyle(fontSize: 14.0, color: Colors.amber)),
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
          ? HomeAppBar()
          : null, // Conditionally show the AppBar only on the Home page
      body: _getPages()[_currentIndex], // Displaying the selected page
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

  // Move the _buildCategoryChip method inside the _HomePageState class
  Widget _buildCategoryChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: Colors.black, // Black text color
            fontSize: 16, // Adjust font size
          ),
        ),
        backgroundColor: Colors.grey[300], // Light grey background
        padding: EdgeInsets.symmetric(
            horizontal: 20.0, vertical: 10.0), // Padding for size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
          side: BorderSide(
            color: Colors.transparent, // Ensure the border is fully transparent
            width: 0, // Set width to 0 to remove the outline
          ),
        ),
        elevation: 0, // Remove any elevation/shadow effect
      ),
    );
  }
}

// Detail page to navigate to
class PhotographerDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photographer Details'),
      ),
      body: Center(
        child: Text('Details about the selected photographer go here.'),
      ),
    );
  }
}