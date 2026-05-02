import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tip_entry.dart';
import '../theme/app_theme.dart';

final DateFormat _weekNumberFormat = DateFormat('w', 'en_ISO');
final DateFormat _weekYearFormat = DateFormat('Y', 'en_ISO');

class _WeekDatum {
  _WeekDatum(this.label, this.value);
  final String label;
  final double value;
}

/// ISO week-year and week number for stable grouping and sort order.
int _weekSortKey(DateTime date) {
  final DateTime local = DateTime(date.year, date.month, date.day);
  final int y = int.parse(_weekYearFormat.format(local));
  final int w = int.parse(_weekNumberFormat.format(local));
  return y * 100 + w;
}

String _weekLabel(DateTime date) {
  final DateTime local = DateTime(date.year, date.month, date.day);
  final String w = _weekNumberFormat.format(local);
  final String y = _weekYearFormat.format(local);
  return 'Week $w $y';
}

/// Bar chart of tip totals grouped by calendar week (ISO week labels).
///
/// Uses [community_charts_flutter], the maintained fork of the discontinued
/// `charts_flutter` package (same chart APIs; `charts_flutter` does not build
/// on current Flutter 3.x / Dart 3).
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key, required this.tips});

  final List<TipEntry> tips;

  @override
  Widget build(BuildContext context) {
    final Map<int, double> totalsByWeek = <int, double>{};
    final Map<int, String> labelByWeek = <int, String>{};

    for (final TipEntry t in tips) {
      final DateTime d = t.date.toLocal();
      final int key = _weekSortKey(d);
      totalsByWeek[key] = (totalsByWeek[key] ?? 0) + t.amount;
      labelByWeek[key] = _weekLabel(d);
    }

    final List<int> sortedKeys = totalsByWeek.keys.toList()..sort();
    final List<_WeekDatum> data = <_WeekDatum>[
      for (final int k in sortedKeys)
        _WeekDatum(labelByWeek[k]!, totalsByWeek[k]!),
    ];

    final List<charts.Series<_WeekDatum, String>> series =
        <charts.Series<_WeekDatum, String>>[
      charts.Series<_WeekDatum, String>(
        id: 'Weekly tips',
        data: data,
        domainFn: (_WeekDatum row, _) => row.label,
        measureFn: (_WeekDatum row, _) => row.value,
        colorFn: (_, _) => charts.ColorUtil.fromDartColor(
          AppTheme.brandOrangeDeep,
        ),
      ),
    ];

    final double total = tips.fold<double>(
      0,
      (double sum, TipEntry t) => sum + t.amount,
    );
    final String totalLabel = NumberFormat.simpleCurrency().format(total);
    final String averageLabel = data.isEmpty
        ? NumberFormat.simpleCurrency().format(0)
        : NumberFormat.simpleCurrency().format(total / data.length);

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Tips Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tips.isEmpty
            ? Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        Icon(
                          Icons.bar_chart,
                          size: 42,
                          color: AppTheme.textSecondary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add tips to see chart',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Total',
                                  style: TextStyle(color: AppTheme.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  totalLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Avg / week',
                                  style: TextStyle(color: AppTheme.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  averageLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        child: charts.BarChart(
                          series,
                          animate: true,
                          vertical: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
