import 'package:flutter/material.dart';

class DashboardTopCreatives extends StatelessWidget {
  const DashboardTopCreatives({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (states) => const Color(0xFFF4F4F4),
        ),
        columns: const [
          DataColumn(
            label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('Sales Volume',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('Higala Films')),
            DataCell(Text('0')),
          ]),
          DataRow(cells: [
            DataCell(Text('Armand Ansaldo Photography')),
            DataCell(Text('0')),
          ]),
          DataRow(cells: [
            DataCell(Text('Hiraya Photography Studio')),
            DataCell(Text('0')),
          ]),
          DataRow(cells: [
            DataCell(Text('Memoirs Films')),
            DataCell(Text('0')),
          ]),
          DataRow(cells: [
            DataCell(Text('The First Day')),
            DataCell(Text('0')),
          ]),
        ],
      ),
    );
  }
}
