import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../domain/pin_policy.dart';
import '../notifier/pin_notifier_provider.dart';
import '../widgets/pin_dots.dart';
import '../widgets/pin_header.dart';
import '../widgets/pin_keypad.dart';
import '../widgets/shake_widget.dart';

class SetTransactionPinScreen extends ConsumerWidget {
  const SetTransactionPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(pinNotifierProvider);
    final pinNotifier = ref.read(pinNotifierProvider.notifier);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    ref.listen(pinNotifierProvider, (previous, next) {
      if (next.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
      if (next.error != null && next.error != previous?.error) {
        showErrorSnackBar(context, next.error!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Transaction PIN'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PinHeader(),
            const SizedBox(height: 8),

            ShakeWidget(
              shake: pinState.shake,
              onComplete: () => pinNotifier.resetShake(),
              child: PinDots(
                filledCount: pinState.isConfirmPhase
                    ? pinState.confirmPin.length
                    : pinState.pin.length,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              pinState.isConfirmPhase
                  ? 'Confirm your ${PinPolicy.length}-digit PIN'
                  : 'Enter a ${PinPolicy.length}-digit PIN',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PinKeypad(
                  disabled: pinState.loading,
                  onKeyPressed: (key) {
                    if (key == '⌫') {
                      pinNotifier.removeDigit();
                    } else if (key == 'OK') {
                      // Only used if user hasn't finished the digits or auto-submit is off
                      pinNotifier.submitPin(context);
                    } else {
                      // Pass context so the notifier can navigate/submit
                      pinNotifier.addDigit(int.parse(key), context);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
