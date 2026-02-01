import 'package:beleema_bank_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

enum TransactionStatus { success, error }

class TransactionResultScreen extends StatelessWidget {
  final TransactionStatus status;
  final Future<void> Function()? onRetry;
  final String title;
  final String message;

  const TransactionResultScreen({
    super.key,
    required this.status,
    required this.title,
    required this.message,
    this.onRetry,
  });

  String get _animationAsset {
    switch (status) {
      case TransactionStatus.success:
        return 'assets/animations/success.json';
      case TransactionStatus.error:
        return 'assets/animations/error.json';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green.shade50;
      case TransactionStatus.error:
        return Colors.red.shade50;
    }
  }

  Color get _titleColor {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green.shade800;
      case TransactionStatus.error:
        return Colors.red.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                SizedBox(
                  width: screenWidth * 0.5,
                  height: screenWidth * 0.5,
                  child: Icon(
                    status == TransactionStatus.success
                        ? Icons.verified_outlined
                        : Icons.error_outline_outlined,
                    size: screenWidth * 0.3,
                    color: _titleColor,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: _titleColor,
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(height: 48),

                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _titleColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      status == TransactionStatus.error
                          ? Navigator.pop(context)
                          : MaterialPageRoute(
                              builder: (_) => DashboardScreen(),
                            );
                    },
                    child: Text(
                      status == TransactionStatus.error
                          ? 'Retry'
                          : 'Back To Dashboard',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
