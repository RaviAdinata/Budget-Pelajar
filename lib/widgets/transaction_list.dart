import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'transaction_form.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(int, Transaction) onEdit;
  final Function(int) onDelete;

  TransactionList({
    required this.transactions,
    required this.onEdit,
    required this.onDelete,
  });

  Map<String, List<MapEntry<int, Transaction>>> get groupedTransactions {
    Map<String, List<MapEntry<int, Transaction>>> map = {};
    for (var entry in transactions.asMap().entries) {
      String dateKey = DateFormat('yyyy-MM-dd').format(entry.value.date);
      map.putIfAbsent(dateKey, () => []).add(entry);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'Belum ada transaksi.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8),
      children: groupedTransactions.entries.map((entry) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title:
                Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
            children: entry.value.map((e) {
              final tx = e.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: tx.isIncome ? Colors.green : Colors.red,
                  child: Icon(
                    tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(tx.description),
                subtitle: Text('Rp ${tx.amount.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => showTransactionForm(
                        context,
                        transaction: tx,
                        index: e.key,
                        onSubmit: (newTx) => onEdit(e.key, newTx),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(e.key),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
