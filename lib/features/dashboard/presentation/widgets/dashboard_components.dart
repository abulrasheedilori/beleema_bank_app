import 'package:beleema_bank_app/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';

import '../../data/models/account_model.dart';
import 'action_buttons.dart';
import 'shortcuts_row.dart';

class DashboardTopSection extends StatelessWidget {
  final AccountModel account;
  final bool hideBalance;
  final VoidCallback onToggleBalance;

  const DashboardTopSection({
    super.key,
    required this.account,
    required this.hideBalance,
    required this.onToggleBalance,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 56, 8, 24),
      decoration: BoxDecoration(
        color: colors.primary,
        // borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileRow(),
          const SizedBox(height: 12),
          _TierAndAccountRow(account.accountNumber),
          const SizedBox(height: 16),
          _BalanceRow(
            balance: account.balance,
            hide: hideBalance,
            onToggle: onToggleBalance,
          ),
          const SizedBox(height: 4),
          _BookBalanceRow(balance: account.balance),
          const SizedBox(height: 4),
          const ActionButtons(),
          const SizedBox(height: 4),
          _ShortcutsHeader(),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class ShortcutsHeader extends StatelessWidget {
  const ShortcutsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(20),
        color: colors.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shortcuts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'View all',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const ShortcutsRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          child: Icon(Icons.account_circle_outlined, size: 36),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello 👋', style: TextStyle(color: Colors.white70)),
            Text(
              'Abdulrasheed',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _TierAndAccountRow extends StatelessWidget {
  final String accountNumber;

  const _TierAndAccountRow(this.accountNumber);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Pill(text: 'Tier 1'),
        const SizedBox(width: 12),
        _Pill(
          child: Row(
            children: [
              Text(accountNumber),
              const SizedBox(width: 6),
              const Icon(Icons.copy, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final Widget? child;
  final String? text;

  const _Pill({this.child, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black12.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white.withOpacity(0.92)),
        child: child ?? Text(text!),
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final double balance;
  final bool hide;
  final VoidCallback onToggle;

  const _BalanceRow({
    required this.balance,
    required this.hide,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          hide ? '***********' : formatAmount(balance),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            hide ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: onToggle,
        ),
      ],
    );
  }
}

class _BookBalanceRow extends StatelessWidget {
  final double balance;

  const _BookBalanceRow({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Book balance',
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),
        Text(
          formatAmount(balance),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ShortcutsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Shortcuts',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}

//Bottom Section
class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          const Text(
            'Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {},
            icon: const Text('See more'),
            label: const Icon(Icons.arrow_forward_ios, size: 14),
          ),
        ],
      ),
    );
  }
}
