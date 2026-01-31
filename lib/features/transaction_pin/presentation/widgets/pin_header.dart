import 'package:flutter/material.dart';

class PinHeader extends StatelessWidget {
  const PinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [Icon(Icons.lock_outline, size: 32, color: colors.primary)],
    );
  }
}
