import 'package:flutter/material.dart';

import '../../../../core/widgets/skeleton_box.dart';

class BalanceSkeleton extends StatelessWidget {
  const BalanceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SkeletonBox(height: 36, width: 200),
          SizedBox(height: 12),
          SkeletonBox(height: 14, width: 140),
        ],
      ),
    );
  }
}
