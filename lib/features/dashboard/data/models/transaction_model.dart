class TransactionModel {
  final String id;
  final String toAccount;
  final double amount;
  final String date;

  TransactionModel({
    required this.id,
    required this.toAccount,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      toAccount: json['toAccount'],
      date: json['date'],
    );
  }
}
