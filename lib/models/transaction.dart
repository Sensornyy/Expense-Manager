class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;
  String category;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}
