import 'package:flutter/material.dart';

class ShortcutsRow extends StatelessWidget {
  const ShortcutsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // slightly taller than cards
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          _Shortcut(icon: Icons.credit_card, label: 'Cards'),
          SizedBox(width: 12),
          _Shortcut(icon: Icons.receipt, label: 'Bills'),
          SizedBox(width: 12),
          _Shortcut(icon: Icons.wallet, label: 'Expenses'),
          SizedBox(width: 12),
          _Shortcut(icon: Icons.save, label: 'Savings'),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Shortcut({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: colors.primary),
              const SizedBox(height: 16),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
