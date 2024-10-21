import 'package:example/screens/ClientUI/client_reviewsandRatings.dart';
import 'package:example/screens/ClientUI/clienthomepage_searchpage.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/ClientUI/client_packagedetails.dart'; // Import the package details page

class CreativesDetailPage extends StatelessWidget {
  const CreativesDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Higala Films',
              style: TextStyle(color: Color(0xFF662C2B))),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Color(0xFF662C2B)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Color(0xFF662C2B)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF662C2B)),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Header with details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side: Image of the logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Rounded corners for image
                        child: Image.asset(
                          'assets/images/higala_logo.png', // Replace with your actual image path
                          width: 80, // Adjusted size for larger image
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between image and text
                      // Middle section: Details (Name, distance, rating, price range)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Business Name and See Reviews in a row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Higala Films',
                                    style: TextStyle(
                                      fontSize: 24, // Larger font size
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Prevent text overflow
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewsPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'See Reviews',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF662C2B),
                                      decoration: TextDecoration
                                          .underline, // Keeps the underline to mimic a link
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Distance
                            const Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Color(0xFF662C2B), size: 24.0),
                                SizedBox(width: 4),
                                Text(
                                  '4.4km away',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Rating row
                            const Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFF662C2B), size: 20),
                                SizedBox(width: 4),
                                Text(
                                  '4.3 1000+ ratings',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height:
                                    4), // Space between rating and price range
                            // Price Range row
                            const Row(
                              children: [
                                Icon(Icons.attach_money,
                                    color: Color(0xFF662C2B), size: 20),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Price Range: ₱5,000 - ₱30,000',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    overflow: TextOverflow
                                        .ellipsis, // Prevent overflow
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Tab bar here
                const TabBar(
                  indicatorColor: Color(0xFF662C2B), // Color of the underline
                  indicatorWeight: 1.0, // Thickness of the underline
                  labelColor:
                      Color(0xFF662C2B), // Color of the selected tab label
                  unselectedLabelColor:
                      Colors.black, // Color of unselected tab labels
                  isScrollable:
                      true, // Allows the tabs to scroll if there are many
                  tabs: [
                    Tab(text: 'Packages'),
                    Tab(text: 'Photos'),
                    Tab(text: 'Videos'),
                  ],
                ),
                // TabBarView content
                Expanded(
                  child: TabBarView(
                    children: [
                      // First Tab: Packages
                      _buildPackagesTab(context),
                      // Second Tab: Photos
                      _buildPhotosTab(context),
                      // Third Tab: Videos
                      _buildVideosTab(context),
                    ],
                  ),
                ),
              ],
            ),
            // Positioned Chat button at the bottom-right corner
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                    onPressed: () {
                      // Handle chat button press
                    },
                    child: const Icon(Icons.message),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Chat with us',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color.fromARGB(255, 0, 0, 0),
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

  // Helper method to create the Packages Tab content
  Widget _buildPackagesTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Popular section
          _buildSectionTitle(
            context,
            Icons.whatshot,
            'Popular',
          ),
          const SizedBox(height: 16),
          _buildPackageGrid(context, [
            {
              'packageName': 'Package 1',
              'price': '₱5,000',
              'imagePath': 'assets/images/package1.png'
            },
            {
              'packageName': 'Package 2',
              'price': '₱5,000',
              'imagePath': 'assets/images/package2.png'
            },
            {
              'packageName': 'Package 3',
              'price': '₱15,000',
              'imagePath': 'assets/images/package3.png'
            },
            {
              'packageName': 'Package 4',
              'price': '₱15,000',
              'imagePath': 'assets/images/package4.png'
            },
          ]),
          const SizedBox(height: 16),
          // Graduation section
          _buildSectionTitle(context, Icons.school, 'Graduation'),
          const SizedBox(height: 16),
          _buildPackageGrid(context, [
            {
              'packageName': 'Package 1',
              'price': '₱5,000',
              'imagePath': 'assets/images/package1.png'
            },
            {
              'packageName': 'Package 2',
              'price': '₱15,000',
              'imagePath': 'assets/images/package2.png'
            },
            {
              'packageName': 'Package 3',
              'price': '₱5,000',
              'imagePath': 'assets/images/package3.png'
            },
            {
              'packageName': 'Package 4',
              'price': '₱15,000',
              'imagePath': 'assets/images/package4.png'
            },
          ]),
          const SizedBox(height: 16),
          // Wedding section
          _buildSectionTitle(context, Icons.cake, 'Weddings'),
          const SizedBox(height: 16),
          _buildPackageGrid(context, [
            {
              'packageName': 'Package 1',
              'price': '₱5,000',
              'imagePath': 'assets/images/package1.png'
            },
            {
              'packageName': 'Package 2',
              'price': '₱15,000',
              'imagePath': 'assets/images/package2.png'
            },
            {
              'packageName': 'Package 3',
              'price': '₱5,000',
              'imagePath': 'assets/images/package3.png'
            },
            {
              'packageName': 'Package 4',
              'price': '₱15,000',
              'imagePath': 'assets/images/package4.png'
            },
          ]),
        ],
      ),
    );
  }

  // Helper method to create the Photos Tab content
  Widget _buildPhotosTab(BuildContext context) {
    return const Center(
      child: Text('Photos will be displayed here'),
    );
  }

  // Helper method to create the Videos Tab content
  Widget _buildVideosTab(BuildContext context) {
    return const Center(
      child: Text('Videos will be displayed here'),
    );
  }

  // Helper method to create section titles
  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Helper method to build a grid of packages
  Widget _buildPackageGrid(
      BuildContext context, List<Map<String, String>> packages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 4 / 5, // Adjusted for rectangle images
        ),
        itemCount: packages.length,
        itemBuilder: (context, index) {
          return _buildPackageCard(
            context,
            packages[index]['packageName']!,
            packages[index]['price']!,
            packages[index]['imagePath']!,
          );
        },
      ),
    );
  }

  // Helper method to build individual package cards
  Widget _buildPackageCard(BuildContext context, String packageName,
      String price, String imagePath) {
    return GestureDetector(
      onTap: () {
        // Navigate to the package details page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PackageDetailsPage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(packageName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price),
        ],
      ),
    );
  }
}
