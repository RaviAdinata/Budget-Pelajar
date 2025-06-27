import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transaction_list.dart';
import '../widgets/balance_summary.dart';

class HomeScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChange;

  const HomeScreen({required this.onThemeChange});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> _transactions = [];
  int? _selectedMonth;
  int? _selectedYear;

  void _addTransaction(Transaction t) {
    setState(() {
      _transactions.add(t);
    });
  }

  void _editTransaction(int index, Transaction t) {
    setState(() {
      _transactions[index] = t;
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  List<Transaction> get _filteredTransactions {
    if (_selectedMonth == null || _selectedYear == null) return _transactions;
    return _transactions
        .where((tx) =>
            tx.date.month == _selectedMonth && tx.date.year == _selectedYear)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String? label;
    if (_selectedMonth != null && _selectedYear != null) {
      label = '${_selectedYear}-${_selectedMonth.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Keuangan Harian'),
        centerTitle: true,
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: Icon(Icons.brightness_6),
            tooltip: 'Ubah Tema',
            onSelected: widget.onThemeChange,
            itemBuilder: (_) => [
              PopupMenuItem(value: ThemeMode.light, child: Text('Mode Terang')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Mode Gelap')),
              PopupMenuItem(
                  value: ThemeMode.system, child: Text('Ikuti Sistem')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'Bulan'),
                    value: _selectedMonth,
                    items: List.generate(12, (i) => i + 1).map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child:
                            Text(DateFormat.MMMM().format(DateTime(0, month))),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedMonth = val),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(labelText: 'Tahun'),
                    value: _selectedYear,
                    items: List.generate(5, (i) => DateTime.now().year - i)
                        .map((year) {
                      return DropdownMenuItem(
                          value: year, child: Text('$year'));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedYear = val),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  tooltip: 'Reset Filter',
                  onPressed: () => setState(() {
                    _selectedMonth = null;
                    _selectedYear = null;
                  }),
                )
              ],
            ),
          ),
          BalanceSummary(transactions: _filteredTransactions, label: label),
          Expanded(
            child: TransactionList(
              transactions: _filteredTransactions,
              onEdit: _editTransaction,
              onDelete: _deleteTransaction,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            showTransactionForm(context, onSubmit: _addTransaction),
        icon: Icon(Icons.add),
        label: Text('Tambah'),
      ),
    );
  }
}
