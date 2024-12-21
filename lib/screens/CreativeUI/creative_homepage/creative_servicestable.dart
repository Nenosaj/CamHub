import 'package:example/screens/responsive_helper.dart';
import 'package:flutter/material.dart';

// Data model for Package Breakdown
class PackageData {
  final String packageName;
  final int sold;

  PackageData(this.packageName, this.sold);
}

// Table widget for Package Breakdown
class PackageBreakdownTable extends StatelessWidget {
  final List<PackageData> packageData;

  const PackageBreakdownTable({super.key, required this.packageData});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3.0,
              blurRadius: 5.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Package Name')),
            DataColumn(label: Text('Sold')),
          ],
          rows: packageData
              .map((package) => DataRow(cells: [
                    DataCell(Text(package.packageName)),
                    DataCell(Text(package.sold.toString())),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
