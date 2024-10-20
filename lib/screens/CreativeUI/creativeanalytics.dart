import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'creativecharts.dart';
import 'creativeservicestable.dart';

class CreativeAnalytics extends StatefulWidget {
  final String creativeName;
  final double rating;
  final double monthlyRevenue;
  final int totalOrders;
  final int totalCustomers;
  final int totalImpressions;

  const CreativeAnalytics({
    super.key,
    required this.creativeName,
    required this.rating,
    required this.monthlyRevenue,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalImpressions,
  });

  @override
  CreativeAnalyticsState createState() => CreativeAnalyticsState();
}

class CreativeAnalyticsState extends State<CreativeAnalytics> {
  bool showFullData =
      false; // This will toggle between current and recent months

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0");

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${widget.creativeName}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(fontSize: 16),
                ),
                const Icon(Icons.star, color: Colors.red),
                Text(
                  widget.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildOverviewTile('Monthly Revenue',
                    '₱${numberFormat.format(widget.monthlyRevenue)}'),
                _buildOverviewTile(
                    'Total Orders', numberFormat.format(widget.totalOrders)),
                _buildOverviewTile('Total Customers',
                    numberFormat.format(widget.totalCustomers)),
                _buildOverviewTile('Total Impressions',
                    numberFormat.format(widget.totalImpressions)),
              ],
            ),
            const SizedBox(height: 20),
            // Adding Sales vs Returns Chart
            const Text(
              'Sales vs. Returns',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300, // Set height for the chart
              child: SalesReturnsChart(
                showFullData
                    ? SalesReturnsChart
                        .createRecentMonthsData() // Show more data
                    : SalesReturnsChart
                        .createCurrentMonthData(), // Show only current month
              ),
            ),
            const SizedBox(height: 10),
            // Button to toggle between showing more months or the current month
            TextButton(
              onPressed: () {
                setState(() {
                  showFullData = !showFullData; // Toggle the data view
                });
              },
              child: Text(
                showFullData ? 'Show Current Month' : 'See Recent Months',
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            // Adding the Service Percentage Table
            const Text(
              'Services Breakdown for Selected Month',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const ServicePercentageTable(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
