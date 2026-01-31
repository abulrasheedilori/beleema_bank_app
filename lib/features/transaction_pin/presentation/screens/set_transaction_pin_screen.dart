// import 'package:flutter/material.dart';
//
// import '../../../../core/utils/show_snackbar.dart';
// import '../../../dashboard/presentation/screens/dashboard_screen.dart';
// import '../../../dashboard/presentation/widgets/balance_skeleton.dart';
// import '../../../dashboard/presentation/widgets/transaction_skeleton_tile.dart';
// import '../../data/pin_repository.dart';
// import '../../domain/pin_policy.dart';
// import '../widgets/pin_dots.dart';
// import '../widgets/pin_header.dart';
// import '../widgets/pin_keypad.dart';
//
// class SetTransactionPinScreen extends StatefulWidget {
//   const SetTransactionPinScreen({super.key});
//
//   @override
//   State<SetTransactionPinScreen> createState() =>
//       _SetTransactionPinScreenState();
// }
//
// class _SetTransactionPinScreenState extends State<SetTransactionPinScreen> {
//   final List<int> _pin = [];
//   bool _loading = false;
//   String? _error;
//
//   final PinRepository _repository = PinRepository();
//   bool get _isComplete => _pin.length == PinPolicy.length;
//
//   Future<void> _submitPin(String pin) async {
//     setState(() => _loading = true);
//
//     try {
//       await _repository.setTransactionPin(pin);
//       if (!mounted) return;
//       setState(() {
//         _pin.clear();
//         _error = null;
//       });
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => DashboardScreen()),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       showErrorSnackBar(context, _error!);
//     } finally {
//       if (!mounted) return;
//
//       setState(() => _loading = false);
//     }
//   }
//
//   void _onKeyPressed(String key) {
//     setState(() => _error = null);
//
//     if (key == '⌫' && _pin.isNotEmpty) {
//       setState(() => _pin.removeLast());
//     } else if (_pin.length < PinPolicy.length && key != '⌫' && key != 'OK') {
//       setState(() => _pin.add(int.parse(key)));
//     } else if (key == 'OK') {
//       if (!_isComplete) {
//         showErrorSnackBar(context, _error!);
//         return;
//       }
//
//       final pinString = _pin.join();
//       _submitPin(pinString);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     if (_loading) {
//       return Scaffold(
//         body: ListView(
//           padding: const EdgeInsets.all(16),
//           children: const [
//             BalanceSkeleton(),
//             SizedBox(height: 24),
//             TransactionSkeletonTile(),
//             TransactionSkeletonTile(),
//             TransactionSkeletonTile(),
//           ],
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Set Transaction PIN'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 8),
//               const PinHeader(),
//               const SizedBox(height: 12),
//               PinDots(filledCount: _pin.length),
//               const SizedBox(height: 12),
//               Text(
//                 'Use a ${PinPolicy.length}-digit PIN',
//                 style: textTheme.bodySmall?.copyWith(
//                   color: colors.onSurfaceVariant,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               PinKeypad(disabled: _loading, onKeyPressed: _onKeyPressed),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../data/pin_repository.dart';
import '../../domain/pin_policy.dart';
import '../../domain/set_transaction_pin_usecases.dart';
import '../provider/set_txn_pin_provider.dart';
import '../widgets/pin_dots.dart';
import '../widgets/pin_header.dart';
import '../widgets/pin_keypad.dart';
import '../widgets/shake_widget.dart';

/// ------------------
/// Riverpod State
/// ------------------
final pinNotifierProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  final repository = PinRepository();
  final usecase = SetTransactionPinUsecase(repository);
  return PinNotifier(usecase);
});

/// ------------------
/// SetTransactionPinScreen
/// ------------------
class SetTransactionPinScreen extends ConsumerWidget {
  const SetTransactionPinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(pinNotifierProvider);
    final pinNotifier = ref.read(pinNotifierProvider.notifier);

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show error snackbar safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pinState.error != null) {
        showErrorSnackBar(context, pinState.error!);
      }
    });

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

            // PinDots(
            //   filledCount: pinState.isConfirmPhase
            //       ? pinState.confirmPin.length
            //       : pinState.pin.length,
            // ),
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
            const SizedBox(height: 4),
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
