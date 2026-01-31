import 'package:flutter/material.dart';

import '../../data/models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  final int index;

  const TransactionTile({super.key, required this.tx, required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isCredit = tx.amount > 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 70)),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: colors.surfaceVariant,
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.green : colors.error,
          ),
        ),
        title: Text(tx.amount.toStringAsFixed(2)),
        subtitle: Text(tx.toAccount),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isCredit ? '+' : '-'}₦${tx.amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                color: isCredit ? Colors.green : colors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(tx.date),
          ],
        ),
      ),
    );
  }
}
