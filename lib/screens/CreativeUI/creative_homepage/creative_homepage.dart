import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/screens/CreativeUI/creative_model/creative_model.dart';
import '../creative_message/creative_userlistscreen.dart';
import '../creative_nofication/creative_nofication.dart';
import '../../Settings/settingspage.dart';
import '../creative_profile/creative_profile.dart';
import 'creative_analytics.dart';
import '../creative_upload/creative_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            MaterialPageRoute(
                builder: (context) => const SettingsPage()), // New route
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
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int totalBookings = 0; // Total Orders
  int totalCustomers = 0; // Total Customers
  double monthlyRevenue = 0.0; // Monthly Revenue
  User? currentUser; // Firebase Authentication User
  String businessName = "Creative"; // Placeholder for business name
  Map<String, int> monthlySales = {}; // To store sales by month
  Map<String, int> packageBreakdown = {}; // To store package sales

  @override
  void initState() {
    super.initState();
    currentUser =
        FirebaseAuth.instance.currentUser; // Get the current authenticated user
    if (currentUser != null) {
      _fetchCreativeDetails(
          currentUser!.uid); // Fetch business name and other details

      _fetchTransactionData(currentUser!.uid); // Fetch metrics
    }
  }

  Future<void> _fetchCreativeDetails(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('creatives')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          businessName = data['businessName'] ??
              "Creative"; // Default to "Creative" if not found
        });
      } else {
        print("Creative not found for uid: $uid");
      }
    } catch (e) {
      print("Error fetching creative details: $e");
    }
  }

  Future<void> _fetchTransactionData(String creativeId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('creativeId', isEqualTo: creativeId)
          .get();

      Map<String, int> salesByMonth = {};
      Map<String, int> packagesSold = {};
      double revenue = 0.0;
      int bookings = 0;
      Set<String> uniqueCustomers = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          print('Transaction data is null for document ID: ${doc.id}');
          continue;
        }

        bookings++;
        revenue += data['totalAmount'] ?? 0.0;
        uniqueCustomers.add(data['clientId'] ?? 'Unknown');

        // Fetch booking details
        String bookingId = data['bookingId'] ?? '';
        DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .get();

        if (!bookingSnapshot.exists) {
          print('Booking document does not exist: $bookingId');
          continue;
        }

        final bookingDetails =
            bookingSnapshot.data() as Map<String, dynamic>? ?? {};
        String date = bookingDetails['date'] ?? 'Unknown';
        String month = date.split('-')[1]; // Extract month

        salesByMonth[month] = (salesByMonth[month] ?? 0) + 1;

        // Fetch the specific package using packageId
        String packageId = data['packageId'] ?? '';
        DocumentSnapshot packageSnapshot = await FirebaseFirestore.instance
            .collection('package')
            .doc(creativeId)
            .collection('uploads')
            .doc(packageId)
            .get();

        if (!packageSnapshot.exists) {
          print('Package document does not exist: $packageId');
          continue;
        }

        final packageDetails =
            packageSnapshot.data() as Map<String, dynamic>? ?? {};
        String packageName = packageDetails['title'] ?? 'Unknown';

        // Group by package name
        packagesSold[packageName] = (packagesSold[packageName] ?? 0) + 1;
      }

      setState(() {
        totalBookings = bookings;
        totalCustomers = uniqueCustomers.length;
        monthlyRevenue = revenue;
        monthlySales = salesByMonth;
        packageBreakdown = packagesSold;
      });
    } catch (e) {
      print('Error fetching transaction data: $e');
    }
  }

  // List of pages for each bottom navigation item
  List<Widget> _getPages() {
    if (currentUser == null) {
      return [
        const Center(
            child:
                CircularProgressIndicator()), // Show loading until creative is fetched
      ];
    }

    // Once the creative is fetched, return the list of pages
    return [
      CreativeAnalytics(
        creativeName: businessName,
        monthlyRevenue: monthlyRevenue,
        totalOrders: totalBookings,
        totalCustomers: totalCustomers,
        monthlySales: monthlySales, // Pass monthly sales
        packageBreakdown: packageBreakdown, // Placeholder for now
      ),
      const UserListScreen(), // Use default values or dynamic fetching within ChatScreen
      const CreativeUploadButton(), // Add button
      const CreativeNotificationPage(), // Navigate to your Notifications Page
      const CreativeProfilePage(), // Navigate to your Profile Page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? const HomeAppBar() : null,
      body: _getPages()[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF7B3A3F),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 2) {
            showDialog(
              context: context,
              builder: (BuildContext context) => const CreativeUploadButton(),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
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
            icon: Icon(Icons.add_circle, size: 35.0), // Add icon integrated
            label: 'Add',
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
