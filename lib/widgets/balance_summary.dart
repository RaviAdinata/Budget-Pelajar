import 'package:flutter/material.dart';
import '../models/transaction.dart';

class BalanceSummary extends StatelessWidget {
  final List<Transaction> transactions;
  final String? label;

  BalanceSummary({required this.transactions, this.label});

  double get totalBalance {
    return transactions.fold(
      0.0,
      (sum, tx) => tx.isIncome ? sum + tx.amount : sum - tx.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.15),
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label != null ? 'Saldo Bulan $label' : 'Saldo Saat Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            Text(
              'Rp ${totalBalance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
