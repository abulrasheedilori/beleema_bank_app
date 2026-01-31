import 'package:beleema_bank_app/features/transfer/presentation/widgets/transfer_result_success.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../auth/data/dto/api_response.dart';
import '../../data/transfer_repository.dart';
import '../../domain/transfer_usecase.dart';
import '../widgets/show_pin_bottom_sheet.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _repo = TransferRepository();
  late final _usecase = TransferUsecase(_repo);

  final _amountController = TextEditingController();
  final _toAccountController = TextEditingController();

  bool _loading = false;
  String? _error;
  double? _newBalance;

  Future<void> _onContinue() async {
    final amount = int.tryParse(_amountController.text);
    final toAccount = _toAccountController.text.trim();

    if (amount == null || amount <= 0 || toAccount.isEmpty) {
      setState(() => _error = 'Please enter valid transfer details');
      return;
    }

    final confirmed = await showTransferSummary(
      context: context,
      amount: amount,
      toAccount: toAccount,
    );

    if (confirmed != true) return;

    if (!mounted) return;
    await showPinBottomSheet(
      context: context,
      onPinEntered: (String pin, {bool biometric = false}) {
        // Call your async transfer function here
        _executeTransfer(pin);
      },
      // onCompleted: (String pin, {bool biometric = false}) {
      //   _executeTransfer(pin);
      // },
    );
  }

  Future<void> _executeTransfer(String pin) async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final response = await _usecase.executeTransfer(
      amount: double.parse(_amountController.text),
      toAccount: _toAccountController.text.trim(),
      pin: pin,
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (response.success && response.data is TransferData) {
      final transferData = response.data as TransferData;

      _amountController.clear();
      _toAccountController.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TransactionResultScreen(
            status: TransactionStatus.success,
            title: "Transaction Successful",
            message:
                'New balance: ${formatAmount(transferData.newBalance.toInt())}',
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TransactionResultScreen(
            status: TransactionStatus.error,
            title: "Transaction Failed",
            message: response.message ?? "Something went wrong",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _toAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {}

    if (_newBalance != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TransactionResultScreen(
            status: TransactionStatus.success,
            title: "Transaction Successful",
            message: 'New balance: ${formatAmount(_newBalance?.toInt() ?? 0)}',
          ),
        ),
      );
    }

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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _onContinue,
              child: _loading
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
  required int amount,
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
