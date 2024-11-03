import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Admin!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            const Text("Welcome back to your panel."),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard("₱525,500", "Total Revenue", Icons.monetization_on),
                _buildCard("1200", "Total Impressions", Icons.remove_red_eye),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard("280", "New Users", Icons.person_add),
                _buildCard("1010", "Existing User", Icons.people),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text("Top-Selling Photographer/Videographer"),
            const SizedBox(height: 10.0),
            _buildTopSellingTable(),
            const SizedBox(height: 20.0),
            const Text("Top-Picks Photographer/Videographer by Reviews"),
            // Continue adding other sections...
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String value, String label, IconData icon) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 160.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellingTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Sales Volume')),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('Higala Films')),
          DataCell(Text('204')),
        ]),
        DataRow(cells: [
          DataCell(Text('Armand Ansaldo Photography')),
          DataCell(Text('190')),
        ]),
        DataRow(cells: [
          DataCell(Text('Hiraya Photography Studio')),
          DataCell(Text('185')),
        ]),
        DataRow(cells: [
          DataCell(Text('Memoirs Films')),
          DataCell(Text('177')),
        ]),
        DataRow(cells: [
          DataCell(Text('The First Day')),
          DataCell(Text('152')),
        ]),
      ],
    );
  }
}
