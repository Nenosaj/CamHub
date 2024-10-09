import 'package:flutter/material.dart';

class ServiceData {
  final String item;
  final double percentage;

  ServiceData(this.item, this.percentage);
}

class MonthlyServiceData {
  final String month;
  final List<ServiceData> services;

  MonthlyServiceData(this.month, this.services);
}

class ServicePercentageTable extends StatefulWidget {
  const ServicePercentageTable({super.key});

  @override
  _ServicePercentageTableState createState() => _ServicePercentageTableState();
}

class _ServicePercentageTableState extends State<ServicePercentageTable> {
  String selectedMonth = 'October';

  // List of service data for each month
  final List<MonthlyServiceData> monthlyData = [
    MonthlyServiceData('October', [
      ServiceData('Weddings', 40.0),
      ServiceData('Portraits', 25.0),
      ServiceData('Events', 20.0),
      ServiceData('Commercial', 15.0),
    ]),
    MonthlyServiceData('September', [
      ServiceData('Weddings', 35.0),
      ServiceData('Portraits', 30.0),
      ServiceData('Events', 20.0),
      ServiceData('Commercial', 15.0),
    ]),
    MonthlyServiceData('August', [
      ServiceData('Weddings', 45.0),
      ServiceData('Portraits', 20.0),
      ServiceData('Events', 25.0),
      ServiceData('Commercial', 10.0),
    ]),
  ];

  // Variables for easier management of UI styling
  final EdgeInsets containerPadding = const EdgeInsets.all(16);
  final double borderRadius = 12.0;
  final Color containerColor = Colors.white;
  final Color shadowColor = Colors.grey.withOpacity(0.3);
  final double shadowSpreadRadius = 3.0;
  final double shadowBlurRadius = 5.0;
  final Offset shadowOffset = const Offset(0, 3);
  final TextStyle columnTextStyle = const TextStyle(fontSize: 14);
  final EdgeInsets dropdownPadding = const EdgeInsets.symmetric(vertical: 20);

  // Function to get the selected month's data
  List<ServiceData> getServiceDataForMonth(String month) {
    return monthlyData.firstWhere((data) => data.month == month).services;
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceData> serviceData = getServiceDataForMonth(selectedMonth);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: dropdownPadding,
            child: DropdownButton<String>(
              value: selectedMonth,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonth = newValue!;
                });
              },
              items: monthlyData
                  .map<DropdownMenuItem<String>>((MonthlyServiceData data) {
                return DropdownMenuItem<String>(
                  value: data.month,
                  child: Text(data.month),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: containerPadding, // Using the variable
            decoration: BoxDecoration(
              color: containerColor, // Background color variable
              borderRadius:
                  BorderRadius.circular(borderRadius), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: shadowColor, // Shadow color variable
                  spreadRadius: shadowSpreadRadius, // Spread radius variable
                  blurRadius: shadowBlurRadius, // Blur radius variable
                  offset: shadowOffset, // Shadow offset variable
                ),
              ],
            ),
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text('Items',
                        style: columnTextStyle)), // Text style variable
                DataColumn(label: Text('Percentage', style: columnTextStyle)),
              ],
              rows: serviceData
                  .map((service) => DataRow(cells: [
                        DataCell(Text(service.item)),
                        DataCell(Text('${service.percentage}%')),
                      ]))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
