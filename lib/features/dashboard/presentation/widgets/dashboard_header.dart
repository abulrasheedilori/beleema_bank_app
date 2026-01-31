import 'package:beleema_bank_app/features/dashboard/data/models/account_model.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final AccountModel account;

  const DashboardHeader({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withOpacity(0.85)],
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hello,'),
                Text(
                  "Ayomide",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Chip(label: Text(account.balance.toStringAsFixed(2))),
                    const SizedBox(width: 8),
                    Chip(label: Text(account.accountNumber)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
    );
  }
}
