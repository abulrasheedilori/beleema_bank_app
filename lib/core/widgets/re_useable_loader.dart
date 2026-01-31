import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final bool loading;

  const FullScreenLoader({super.key, required this.loading});

  @override
  Widget build(BuildContext context) {
    if (!loading) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Semi-transparent overlay that blocks all gestures
        ModalBarrier(
          dismissible: false,
          color: colors.background.withOpacity(0.6),
        ),

        // Centered exotic loader
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Securing your PIN...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
