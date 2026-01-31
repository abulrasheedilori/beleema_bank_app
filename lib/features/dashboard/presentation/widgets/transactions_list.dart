import 'package:beleema_bank_app/features/dashboard/presentation/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

import '../../data/models/transaction_model.dart';

class TransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(
            child: Column(
              children: const [
                Icon(Icons.receipt_long, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'No transactions yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final tx = transactions[index];
        return TransactionTile(tx: tx, index: index);
      }, childCount: transactions.length),
    );
  }
}
