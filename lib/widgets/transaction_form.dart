import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

void showTransactionForm(
  BuildContext context, {
  required Function(Transaction) onSubmit,
  Transaction? transaction,
  int? index,
}) {
  final formKey = GlobalKey<FormState>();
  DateTime date = transaction?.date ?? DateTime.now();
  String desc = transaction?.description ?? '';
  double amount = transaction?.amount ?? 0;
  bool isIncome = transaction?.isIncome ?? true;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title:
            Text(transaction == null ? 'Tambah Transaksi' : 'Edit Transaksi'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: desc,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  validator: (value) =>
                      value!.isEmpty ? 'Deskripsi wajib diisi' : null,
                  onSaved: (value) => desc = value!,
                ),
                TextFormField(
                  initialValue: amount == 0 ? '' : amount.toString(),
                  decoration: InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Jumlah wajib diisi' : null,
                  onSaved: (value) => amount = double.parse(value!),
                ),
                ListTile(
                  title:
                      Text("Tanggal: ${DateFormat('yyyy-MM-dd').format(date)}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => date = picked);
                    }
                  },
                ),
                DropdownButtonFormField<bool>(
                  value: isIncome,
                  decoration: InputDecoration(labelText: 'Tipe Transaksi'),
                  items: [
                    DropdownMenuItem(value: true, child: Text('Pemasukan')),
                    DropdownMenuItem(value: false, child: Text('Pengeluaran')),
                  ],
                  onChanged: (value) => setState(() => isIncome = value!),
                )
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                onSubmit(Transaction(
                  date: date,
                  amount: amount,
                  description: desc,
                  isIncome: isIncome,
                ));
                Navigator.pop(context);
              }
            },
            child: Text('Simpan'),
          )
        ],
      ),
    ),
  );
}
