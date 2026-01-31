import 'package:intl/intl.dart';

String formatAmount(num amount, {String symbol = '₦', int decimalDigits = 2}) {
  final formatter = NumberFormat.currency(
    symbol: symbol,
    decimalDigits: decimalDigits,
  );

  return formatter.format(amount);
}
