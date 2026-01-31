import 'package:flutter/material.dart';

import '../../domain/pin_policy.dart';

class PinDots extends StatelessWidget {
  final int filledCount;

  const PinDots({super.key, required this.filledCount});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        PinPolicy.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < filledCount ? colors.primary : colors.outlineVariant,
          ),
        ),
      ),
    );
  }
}
