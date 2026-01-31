import 'package:flutter/material.dart';

import '../../../../core/utils/local_auth.dart';
import 'pin_keypad.dart';

Future<void> showPinBottomSheet({
  required BuildContext context,
  // required final void Function(String pin) onCompleted,
  required void Function(String pin, {bool biometric}) onPinEntered,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter Transaction PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            PinKeypad(
              onCompleted: (pin) {
                Navigator.pop(context);
                onPinEntered(pin);
              },
            ),

            //@Todo - check context inside async issue biometric option
            TextButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text('Use biometrics'),
              onPressed: () async {
                final navigator = Navigator.of(context);
                final ok = await authenticateBiometric();
                if (!navigator.mounted) return;

                if (ok) {
                  navigator.pop();
                  onPinEntered('', biometric: true);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
