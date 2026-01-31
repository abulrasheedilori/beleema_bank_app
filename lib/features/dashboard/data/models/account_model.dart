class AccountModel {
  final String accountNumber;
  final double balance;

  AccountModel({required this.accountNumber, required this.balance});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      accountNumber: json['accountNumber'],
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
