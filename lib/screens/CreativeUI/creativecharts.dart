import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

// Data model for Sales and Returns
class SalesData {
  final String month;
  final int sales;
  final int returns;

  SalesData(this.month, this.sales, this.returns);
}

// Bar chart widget for Sales vs Returns
class SalesReturnsChart extends StatelessWidget {
  final List<charts.Series<SalesData, String>> seriesList;
  final bool animate;

  const SalesReturnsChart(this.seriesList, {super.key, this.animate = true});

  @override
Widget build(BuildContext context) {
  return AnimatedSwitcher( // Wrap the chart in AnimatedSwitcher
    duration: const Duration(milliseconds: 500),
    transitionBuilder: (Widget child, Animation<double> animation) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: charts.BarChart( // Your existing BarChart widget
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [
        charts.SeriesLegend(),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              //final selectedDatum = model.selectedDatum[0].datum as SalesData;
              //print('Sales: ${selectedDatum.sales}, Returns: ${selectedDatum.returns}');
            }
          },
        ),
      ],
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 45,
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: const charts.BasicNumericTickProviderSpec(
          desiredMaxTickCount: 5,
        ),
        viewport: const charts.NumericExtents(0, 15),
        renderSpec: charts.GridlineRendererSpec(
          lineStyle: charts.LineStyleSpec(
            thickness: 1,
            color: charts.MaterialPalette.gray.shadeDefault,
          ),
        ),
      ),
    ),
  );
}

  // Static method to create data for current month
  static List<charts.Series<SalesData, String>> createCurrentMonthData() {
    final data = [
      SalesData('October', 12, 2), // Example for the current month
    ];

    return [
      charts.Series<SalesData, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (SalesData sales, _) => sales.month,
        measureFn: (SalesData sales, _) => sales.sales,
        data: data,
      ),
      charts.Series<SalesData, String>(
        id: 'Returns',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (SalesData sales, _) => sales.month,
        measureFn: (SalesData sales, _) => sales.returns,
        data: data,
      ),
    ];
  }

  // Static method to create data for recent months
  static List<charts.Series<SalesData, String>> createRecentMonthsData() {
    final data = [
      SalesData('July', 8, 1),
      SalesData('August', 10, 1),
      SalesData('September', 9, 2),
      SalesData('October', 12, 2), // Current month
    ];

    return [
      charts.Series<SalesData, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (SalesData sales, _) => sales.month,
        measureFn: (SalesData sales, _) => sales.sales,
        data: data,
      ),
      charts.Series<SalesData, String>(
        id: 'Returns',
        colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
        domainFn: (SalesData sales, _) => sales.month,
        measureFn: (SalesData sales, _) => sales.returns,
        data: data,
      ),
    ];
  }
}

