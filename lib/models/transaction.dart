class Transaction {
  DateTime date;
  double amount;
  String description;
  bool isIncome;

  Transaction({
    required this.date,
    required this.amount,
    required this.description,
    required this.isIncome,
  });
}
