import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardAnalytics extends StatefulWidget {
  const DashboardAnalytics({super.key});

  @override
  State<DashboardAnalytics> createState() => _DashboardAnalyticsState();
}

class _DashboardAnalyticsState extends State<DashboardAnalytics> {
  int _existingUsers = 0; // Variable to store user count

  static const String _apiKey =
      'sk_test_4VAEtfCEfXXyU2iqEM73gjtj'; // Replace with your PayMongo API key
  static const String _paymentsUrl = 'https://api.paymongo.com/v1/payments';

  List<Map<String, dynamic>> payments = [];
  bool isLoading = true;
  double totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    _fetchExistingUsers();
    fetchPayments();
  }

  // Fetch user count from Firestore
  Future<void> _fetchExistingUsers() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _existingUsers = usersSnapshot.docs.length;
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user count: $e");
    }
  }

  Future<void> fetchPayments() async {
    try {
      final response = await http.get(
        Uri.parse(_paymentsUrl),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode("$_apiKey:"))}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> paymentsList = data['data'];
        double calculatedRevenue = 0;

        setState(() {
          payments = paymentsList.map((payment) {
            final attributes = payment['attributes'] as Map<String, dynamic>;
            final amount = attributes['amount'] ?? 0;
            final fee = attributes['fee'] ?? 0;
            final netAmount = (amount - fee) / 100; // Convert to currency unit
            calculatedRevenue += netAmount; // Accumulate revenue
            attributes['net_amount'] =
                netAmount; // Add net amount to attributes
            return attributes;
          }).toList();

          totalRevenue = calculatedRevenue;
          isLoading = false;
        });
      } else {
        print('Failed to fetch payments. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching payments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Analytics'),
        backgroundColor: Color(0xFF662C2B),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stat Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "${totalRevenue.toStringAsFixed(2)}",
                        "Total Revenue",
                        Icons.monetization_on,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: _buildStatCard(
                        "0",
                        "Total Impressions",
                        Icons.remove_red_eye,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        "0",
                        "New Users",
                        Icons.person_add,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: _buildStatCard(
                        _existingUsers.toString(),
                        "Existing Users",
                        Icons.people,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Payments Table",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF662C2B),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Clickable Table
                InkWell(
                  onTap: () {
                    _showExpandedTableDialog(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Click to view full Payments Table",
                        style: TextStyle(
                          color: Color(0xFF662C2B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExpandedTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payments Table",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF662C2B),
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey.shade200),
                        columns: const [
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Fees')),
                          DataColumn(label: Text('Net Amount')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Currency')),
                          DataColumn(label: Text('Description')),
                        ],
                        rows: payments.map((payment) {
                          final amount = (payment['amount'] ?? 0) / 100;
                          final fee = (payment['fee'] ?? 0) / 100;
                          final netAmount = payment['net_amount'] ?? 0;
                          return DataRow(cells: [
                            DataCell(Text(amount.toStringAsFixed(2))),
                            DataCell(Text(fee.toStringAsFixed(2))),
                            DataCell(Text(netAmount.toStringAsFixed(2))),
                            DataCell(Text(payment['status'] ?? 'N/A')),
                            DataCell(Text(payment['currency'] ?? 'N/A')),
                            DataCell(Text(payment['description'] ?? 'N/A')),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(
                          color: Color(0xFF662C2B),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(icon, color: Colors.black54),
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
