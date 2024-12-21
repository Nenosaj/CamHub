import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class MonthlySalesData {
  final String month;
  final int sales;

  MonthlySalesData(this.month, this.sales);
}

class MonthlySalesChart extends StatelessWidget {
  final List<charts.Series<MonthlySalesData, String>> seriesList;
  final bool animate;

  const MonthlySalesChart(this.seriesList, {super.key, this.animate = true});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 0, // Keep labels horizontal for readability
          labelStyle: charts.TextStyleSpec(
            fontSize: 14,
            color: charts.MaterialPalette.black,
          ),
        ),
        showAxisLine: true,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
          desiredTickCount: 6, // Adjust for better granularity
        ),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(
            thickness: 1,
            color: charts.MaterialPalette.gray.shade300,
          ),
          labelStyle: const charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      behaviors: [
        charts.ChartTitle(
          'Monthly Sales',
          behaviorPosition: charts.BehaviorPosition.top,
          titleStyleSpec: charts.TextStyleSpec(
            fontSize: 16,
            fontWeight: 'bold',
          ),
        ),
        charts.ChartTitle(
          'Months',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
        ),
        charts.ChartTitle(
          'Sales',
          behaviorPosition: charts.BehaviorPosition.start,
          titleStyleSpec: charts.TextStyleSpec(fontSize: 14),
        ),
      ],
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(10), // Rounded corners
        barRendererDecorator: charts.BarLabelDecorator<String>(), // Data labels
      ),
    );
  }

  static List<charts.Series<MonthlySalesData, String>> createMonthlySalesData(
      Map<String, int> monthlySales) {
    final data = monthlySales.entries
        .map((entry) => MonthlySalesData(entry.key, entry.value))
        .toList();

    return [
      charts.Series<MonthlySalesData, String>(
        id: 'Monthly Sales',
        colorFn: (_, index) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (MonthlySalesData sales, _) => sales.month,
        measureFn: (MonthlySalesData sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (MonthlySalesData sales, _) =>
            '${sales.sales}', // Show sales value on the bar
      ),
    ];
  }
}
