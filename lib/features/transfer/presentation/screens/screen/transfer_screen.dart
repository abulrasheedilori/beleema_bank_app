import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/currency_formatter.dart';
import '../../../../auth/data/dto/api_response.dart';
import '../../widgets/show_pin_bottom_sheet.dart';
import '../../widgets/transfer_result_success.dart';
import '../notifier/transfer_screen_notifier_provider.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _amountController = TextEditingController();
  final _toAccountController = TextEditingController();

  Future<void> _onContinue(WidgetRef ref, BuildContext context) async {
    final notifier = ref.read(transferNotifierProvider.notifier);
    final state = ref.watch(transferNotifierProvider);

    // Update notifier state from text fields
    notifier.updateAmount(_amountController.text);
    notifier.updateToAccount(_toAccountController.text.trim());

    // Validate inputs
    if (!notifier.validateInputs()) return;

    final updatedState = ref.read(transferNotifierProvider);

    // Show transfer summary
    final confirmed = await showTransferSummary(
      context: context,
      amount: updatedState.amount ?? 0.0,
      toAccount: updatedState.toAccount ?? "",
    );

    if (confirmed != true) return;

    // Show PIN bottom sheet
    if (!context.mounted) return;
    await showPinBottomSheet(
      context: context,
      onPinEntered: (pin, {bool biometric = false}) async {
        await notifier.executeTransfer(pin);

        // Check result from state
        final result = notifier.state.result;
        if (result == null) return;

        if (result.success && result.data is TransferData) {
          final data = result.data as TransferData;
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => TransactionResultScreen(
                status: TransactionStatus.success,
                title: 'Transaction Successful',
                message:
                    'New balance: ${formatAmount(data.newBalance.toInt())}',
              ),
            ),
          );
        } else {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TransactionResultScreen(
                status: TransactionStatus.error,
                title: 'Transaction Failed',
                message: result.message ?? 'Something went wrong',
                onRetry: () async {
                  notifier.clearResult();
                  await _onContinue(ref, context); // retry
                },
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _toAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transfer'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _toAccountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'To Account'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
              ],
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: state.loading
                  ? null
                  : () => _onContinue(ref, context), // pass ref + context
              child: state.loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showTransferSummary({
  required BuildContext context,
  required double amount,
  required String toAccount,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Confirm Transfer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          _SummaryRow('Amount', formatAmount(amount)),
          _SummaryRow('To Account', toAccount),
          _SummaryRow('Fee', '₦0.00'),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
