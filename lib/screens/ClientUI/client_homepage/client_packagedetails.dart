import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/ClientUI/client_homepage/client_bookingdetails.dart';

class PackageDetailsPage extends StatefulWidget {
  final String uuid;

  const PackageDetailsPage({super.key, required this.uuid});

  @override
  PackageDetailsPageState createState() => PackageDetailsPageState();
}

class PackageDetailsPageState extends State<PackageDetailsPage> {
  Map<String, dynamic> packageData = {}; // To store package details
  Map<String, bool> addOns = {}; // Add-ons with selected state
  Map<String, String> addOnPrices = {}; // Add-on prices
  String uid = '';

  bool isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    uid = widget.uuid; // Accessing the uuid from the widget
    fetchPackageDetails(uid: uid); // Fetch package details on init
  }

  // Function to fetch package details from Firestore
  Future<void> fetchPackageDetails({required String uid}) async {
    try {
      if (uid.isEmpty) {
        throw Exception("UID is empty");
      }

      // Query the uploads subcollection under the specific UID
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('package') // Main collection
          .doc(uid) // Parent document UID
          .collection('uploads') // Subcollection 'uploads'
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assume we fetch the first document for simplicity
        Map<String, dynamic> data =
            snapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          packageData = data;
          // Convert addOns to a Map<String, bool>
          addOns = Map.fromIterable(
            (data['addOns'] as List<dynamic>?) ?? [],
            key: (e) => e['addOn'] as String,
            value: (_) => false, // Initial unchecked state
          );

          // Convert addOn prices
          addOnPrices = Map.fromIterable(
            (data['addOns'] as List<dynamic>?) ?? [],
            key: (e) => e['addOn'] as String,
            value: (e) => '₱${e['price']}',
          );

          isLoading = false;
        });
      } else {
        print('No package data found in uploads.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching package details: $e');
    }
  }

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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : packageData.isEmpty
              ? const Center(child: Text('Package not found.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Package image
                          Image.network(
                            packageData['package'] ??
                                'https://via.placeholder.com/150',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          // Package details
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                packageData['title'] ?? 'Package Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Price: ${packageData['price'] ?? '₱0'}',
                                style: const TextStyle(fontSize: 14),
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
                      Text(
                        packageData['description'] ??
                            'No description provided.',
                        style: const TextStyle(fontSize: 12),
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
                      _buildAddOnsWidget(), // Add-ons widget
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
                                    uuid: uid, // Package UUID
                                    packageName: packageData['title'] ??
                                        'N/A', // Package name
                                    packagePrice: packageData['price'] ??
                                        '₱0', // Package price
                                    addOns: addOns, // Selected add-ons
                                    addOnPrices: addOnPrices, // Add-on prices
                                    totalAddOnCost:
                                        addOnCost, // Total add-ons cost
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
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Widget for add-ons
  Widget _buildAddOnsWidget() {
    return Column(
      children: addOns.keys.map((String key) {
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
                      value: addOns[key] ?? false,
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
              Text(addOnPrices[key] ?? '₱0'),
            ],
          ),
        );
      }).toList(),
    );
  }
}
