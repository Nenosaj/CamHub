import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'creative_charts.dart';
import 'creative_servicestable.dart';

class CreativeAnalytics extends StatefulWidget {
  final String creativeName;
  final double monthlyRevenue;
  final int totalOrders;
  final int totalCustomers;
  final Map<String, int> monthlySales;
  final Map<String, int> packageBreakdown;

  const CreativeAnalytics({
    super.key,
    required this.creativeName,
    required this.monthlyRevenue,
    required this.totalOrders,
    required this.totalCustomers,
    required this.monthlySales,
    required this.packageBreakdown,
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
            // Greeting Section
            Text(
              'Hello, ${widget.creativeName}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Overview Section
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
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Sales Chart Section
            const Text(
              'Monthly Sales',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: MonthlySalesChart(
                MonthlySalesChart.createMonthlySalesData(widget.monthlySales),
              ),
            ),
            const SizedBox(height: 20),

            // Package Breakdown Table Section
            const Text(
              'Package Breakdown',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PackageBreakdownTable(
              packageData: widget.packageBreakdown.entries
                  .map((entry) => PackageData(entry.key, entry.value))
                  .toList(),
            ),
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
