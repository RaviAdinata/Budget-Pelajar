// lib/widgets/finance_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class FinanceChart extends StatelessWidget {
  final List<Transaction> transactions;

  FinanceChart({required this.transactions});

  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  @override
  Widget build(BuildContext context) {
    final maxY =
        [totalIncome, totalExpense].reduce((a, b) => a > b ? a : b) * 1.2;

    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: maxY == 0 ? 1000 : maxY,
            barGroups: [
              BarChartGroupData(x: 0, barRods: [
                BarChartRodData(
                    toY: totalIncome, color: Colors.green, width: 24),
              ]),
              BarChartGroupData(x: 1, barRods: [
                BarChartRodData(
                    toY: totalExpense, color: Colors.red, width: 24),
              ]),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Pemasukan');
                      case 1:
                        return Text('Pengeluaran');
                      default:
                        return Text('');
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }
}
