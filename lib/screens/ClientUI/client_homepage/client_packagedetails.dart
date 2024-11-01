import 'package:example/screens/ClientUI/client_homepage/client_bookingdetails.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/CreativeUI/creative_profile/creative_profile_reviews.dart';

class PackageDetailsPage extends StatefulWidget {
  const PackageDetailsPage({super.key});

  @override
  PackageDetailsPageState createState() => PackageDetailsPageState();
}

class PackageDetailsPageState extends State<PackageDetailsPage> {
  Map<String, bool> addOns = {
    'Drone shot': false,
    '5 more pictures': false,
    '1-minute video': false,
    '2-minutes video': false,
    '3-minutes video': false,
  };

  Map<String, String> addOnPrices = {
    'Drone shot': '₱3,000',
    '5 more pictures': '₱500',
    '1-minute video': '₱1,000',
    '2-minutes video': '₱2,000',
    '3-minutes video': '₱3,000',
  };

  // Function to calculate total add-ons cost
  int _calculateAddOnCost() {
    int total = 0;
    addOns.forEach((key, value) {
      if (value) {
        total += int.parse(addOnPrices[key]!.replaceAll(RegExp(r'[^\d]'), ''));
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Package',
          style: TextStyle(color: Color(0xFF662C2B)),
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
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHigalaFilmsHeader(),
            const Divider(height: 20, thickness: 2), // Line separator
            Row(
              children: [
                // Package image
                Image.asset(
                  'assets/images/package1.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Package 1',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Price: ₱5,000',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Overview about the package:',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Description about the package',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 120),
            const Text(
              'Add ons:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildAddOnsWidget(), // This will include "See more" button inside
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    int addOnCost = _calculateAddOnCost();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PackageBookingdetails(
                          addOns: addOns,
                          addOnCost: addOnCost,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF662C2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white), // Set the text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the Higala Films header
  Widget _buildHigalaFilmsHeader() {
    return Row(
      children: [
        // Higala Films logo
        Image.asset(
          'assets/images/higala_logo.png',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Higala Films',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '4.3 ★ 1000+ ratings',
              style: TextStyle(fontSize: 12),
            ),
            const Text(
              '4.4km away',
              style: TextStyle(fontSize: 12),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreativeReviews(),
                  ),
                );
              },
              child: const Text(
                'See Reviews',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF662C2B),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Function to build the Add-ons section
  Widget _buildAddOnsWidget() {
    return Column(
      children: [
        ...addOns.keys.map((String key) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: addOns[key] ?? false, // Ensures null-safety
                        onChanged: (bool? value) {
                          setState(() {
                            addOns[key] = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF662C2B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(key),
                  ],
                ),
                Text(addOnPrices[key] ?? ''), // Ensures null-safety
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft, // Align to the right
          child: GestureDetector(
            onTap: () {
              // Handle 'See More' functionality
            },
            child: const Text(
              'See more',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF662C2B),
                fontFamily: 'Inter',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
