import 'package:flutter/material.dart';
import 'package:example/screens/ClientUI/client_reviewsandRatings.dart';
import 'package:example/screens/ClientUI/clienthomepage_searchpage.dart';
import 'package:example/screens/ClientUI/client_packagedetails.dart';
import 'package:example/screens/CreativeUI/creative_model.dart';

class CreativesDetailPage extends StatelessWidget {
  final Map<String, dynamic> creative;

  const CreativesDetailPage({super.key, required this.creative});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            creative['businessName'] ?? 'Creative Details',
            style: const TextStyle(color: Color.fromARGB(255, 48, 45, 44)),
          ),
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
                // Your SearchPage navigation here
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          creative['profilePicture'] ?? 'https://via.placeholder.com/150',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    creative['businessName'] ?? 'Creative',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Your reviews navigation here
                                  },
                                  child: const Text(
                                    'See Reviews',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF662C2B),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF662C2B), size: 24.0),
                                const SizedBox(width: 4),
                                Text(
                                  '4.4km away',
                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFF662C2B), size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${creative['rating']?.toString() ?? 'N/A'} Ratings',
                                  style: const TextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.attach_money, color: Color(0xFF662C2B), size: 20),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Price Range: ₱5,000 - ₱30,000',
                                    style: TextStyle(fontSize: 14, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
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
                const TabBar(
                  indicatorColor: Color(0xFF662C2B),
                  indicatorWeight: 1.0,
                  labelColor: Color(0xFF662C2B),
                  unselectedLabelColor: Colors.black,
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'Packages'),
                    Tab(text: 'Photos'),
                    Tab(text: 'Videos'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildPackagesTab(context),
                      _buildPhotosTab(context),
                      _buildVideosTab(context),
                    ],
                  ),
                ),
              ],
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
          _buildSectionTitle(context, Icons.whatshot, 'Popular'),
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

  // Helper method to build a section title
  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
          childAspectRatio: 4 / 5,
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
  Widget _buildPackageCard(
      BuildContext context, String packageName, String price, String imagePath) {
    return GestureDetector(
      onTap: () {
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
          Text(packageName, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price),
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
}
