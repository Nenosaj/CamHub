import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'creativecharts.dart';

class CreativeAnalytics extends StatefulWidget {
  final String creativeName;
  final double rating;
  final double monthlyRevenue;
  final int totalOrders;
  final int totalCustomers;
  final int totalImpressions;

  CreativeAnalytics({
    required this.creativeName,
    required this.rating,
    required this.monthlyRevenue,
    required this.totalOrders,
    required this.totalCustomers,
    required this.totalImpressions,
  });

  @override
  _CreativeAnalyticsState createState() => _CreativeAnalyticsState();
}

class _CreativeAnalyticsState extends State<CreativeAnalytics> {
  bool showFullData = false; // This will toggle between current and recent months

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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Rating: ',
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.star, color: Colors.red),
                Text(
                  '${widget.rating.toStringAsFixed(1)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildOverviewTile('Monthly Revenue', '₱${numberFormat.format(widget.monthlyRevenue)}'),
                _buildOverviewTile('Total Orders', numberFormat.format(widget.totalOrders)),
                _buildOverviewTile('Total Customers', numberFormat.format(widget.totalCustomers)),
                _buildOverviewTile('Total Impressions', numberFormat.format(widget.totalImpressions)),
              ],
            ),
            SizedBox(height: 20),
            // Adding Sales vs Returns Chart
            Text(
              'Sales vs. Returns',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300, // Set height for the chart
              child: SalesReturnsChart(
                showFullData
                    ? SalesReturnsChart.createRecentMonthsData() // Show more data
                    : SalesReturnsChart.createCurrentMonthData(), // Show only current month
              ),
            ),
            SizedBox(height: 10),
            // Button to toggle between showing more months or the current month
            TextButton(
              onPressed: () {
                setState(() {
                  showFullData = !showFullData; // Toggle the data view
                });
              },
              child: Text(
                showFullData ? 'Show Current Month' : 'See Recent Months',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            // You can add more content below
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTile(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
