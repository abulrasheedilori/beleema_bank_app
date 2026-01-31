// import 'package:flutter/material.dart';
//
// class PinKeypad extends StatelessWidget {
//   final bool disabled;
//   final void Function(String) onKeyPressed;
//
//   const PinKeypad({
//     super.key,
//     required this.onKeyPressed,
//     this.disabled = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//
//     final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '⌫', '0', "OK"];
//
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: keys.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 8,
//         crossAxisSpacing: 8,
//       ),
//       itemBuilder: (_, index) {
//         final key = keys[index];
//         if (key.isEmpty) return const SizedBox();
//
//         return GestureDetector(
//           onTap: disabled ? null : () => onKeyPressed(key),
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: (key == "OK") ? colors.primary : colors.surface,
//               border: Border.all(color: colors.outline),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               key,
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//                 color: colors.onSurface,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';

class PinKeypad extends StatelessWidget {
  final bool disabled;
  final void Function(String) onKeyPressed;

  const PinKeypad({
    super.key,
    required this.onKeyPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '⌫', '0', "OK"];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic sizing based on available width
        // This ensures the keypad doesn't overflow on tiny screens (like an iPhone SE)
        double maxWidth = constraints.maxWidth;
        double padding = 16.0;
        double spacing = 8.0;

        // Determine font size based on screen width
        double fontSize = maxWidth < 350 ? 18 : 22;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: keys.length,
          padding: EdgeInsets.symmetric(horizontal: padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            // childAspectRatio 1.0 keeps the Container a perfect square,
            // which allows BoxShape.circle to look correct.
            childAspectRatio: 1.0,
          ),
          itemBuilder: (_, index) {
            final key = keys[index];

            return InkWell(
              // Switched to InkWell for better touch feedback
              onTap: disabled ? null : () => onKeyPressed(key),
              borderRadius: BorderRadius.circular(100),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (key == "OK") ? colors.primary : colors.surface,
                  border: Border.all(color: colors.outline.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    // Ensure "OK" text is readable on primary color
                    color: (key == "OK") ? colors.onPrimary : colors.onSurface,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
