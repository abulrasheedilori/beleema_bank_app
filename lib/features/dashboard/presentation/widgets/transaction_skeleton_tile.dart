import 'package:flutter/material.dart';

import '../../../../core/widgets/skeleton_box.dart';

class TransactionSkeletonTile extends StatelessWidget {
  const TransactionSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: const [
          SkeletonBox(
            height: 40,
            width: 40,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 14),
                SizedBox(height: 8),
                SkeletonBox(height: 12, width: 120),
              ],
            ),
          ),
          SizedBox(width: 12),
          SkeletonBox(height: 14, width: 80),
        ],
      ),
    );
  }
}
