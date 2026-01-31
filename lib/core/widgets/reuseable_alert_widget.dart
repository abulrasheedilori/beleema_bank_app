import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum AlertType { success, error, info }

class AlertMessage extends StatelessWidget {
  final String message;
  final AlertType type;
  final VoidCallback? onOk;

  const AlertMessage({
    super.key,
    required this.message,
    this.type = AlertType.info,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context).textTheme;

    Color bgColor;
    Color iconBgColor;
    String asset;

    switch (type) {
      case AlertType.success:
        bgColor = colors.secondaryContainer.withOpacity(0.95);
        iconBgColor = Colors.greenAccent.shade100;
        asset = 'assets/animations/success.json';
        break;
      case AlertType.error:
        bgColor = colors.errorContainer.withOpacity(0.95);
        iconBgColor = Colors.redAccent.shade100;
        asset = 'assets/animations/error.json';
        break;
      case AlertType.info:
      default:
        bgColor = colors.primaryContainer.withOpacity(0.95);
        iconBgColor = Colors.blueAccent.shade100;
        asset = 'assets/animations/info.json';
    }

    return WillPopScope(
      onWillPop: () async => false, // Prevent dismiss by back button
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        body: Center(
          child: AnimatedScale(
            scale: 1,
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            child: Container(
              constraints: const BoxConstraints(minWidth: 280, maxWidth: 400),
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      asset,
                      width: 80,
                      height: 80,
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Message
                  Text(
                    message.substring(1, 10),
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // OK Button
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: colors.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onOk != null) onOk!();
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
