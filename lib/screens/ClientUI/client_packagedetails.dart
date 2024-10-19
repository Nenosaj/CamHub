import 'package:flutter/material.dart';

class PackageDetailsPage extends StatelessWidget {
  const PackageDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF662C2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Higala Films',
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
            Row(
              children: [
                // Placeholder for the logo
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: Center(child: Text('Logo')),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Higala Films',
                      style: TextStyle(
                        fontSize: 18,
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
                      onTap: () {
                        // Add See Reviews navigation
                      },
                      child: const Text(
                        'See Reviews',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Placeholder for package image
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('Image')),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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
            const SizedBox(height: 20),
            const Text(
              'Add ons:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            AddOnsWidget(),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add continue button functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF662C2B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddOnsWidget extends StatefulWidget {
  const AddOnsWidget({super.key});

  @override
  _AddOnsWidgetState createState() => _AddOnsWidgetState();
}

class _AddOnsWidgetState extends State<AddOnsWidget> {
  Map<String, bool> addOns = {
    'Drone shot (+₱3,000)': false,
    '5 more pictures (+₱500)': false,
    '1-minute video (+₱1,000)': false,
    '2-minutes video (+₱2,000)': false,
    '3-minutes video (+₱3,000)': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: addOns.keys.map((String key) {
        return CheckboxListTile(
          activeColor: const Color(0xFF662C2B),
          title: Text(key),
          value: addOns[key],
          onChanged: (bool? value) {
            setState(() {
              addOns[key] = value ?? false;
            });
          },
        );
      }).toList(),
    );
  }
}
