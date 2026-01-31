import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double bookBalance;
  final bool hide;
  final VoidCallback onToggle;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.bookBalance,
    required this.hide,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                hide ? '₦ ******' : '₦ ${balance.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  hide ? Icons.visibility_off : Icons.visibility,
                  color: colors.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Book balance ₦${bookBalance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
