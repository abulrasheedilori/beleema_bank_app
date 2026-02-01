import 'package:beleema_bank_app/features/transaction_pin/presentation/notifier/set_txn_pin_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/pin_repository_provider.dart';
import '../../domain/usecase/set_transaction_pin_usecases.dart';

final pinNotifierProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  final repository = ref.read(pinRepositoryProvider);
  final usecase = SetTransactionPinUsecase(repository);
  return PinNotifier(usecase);
});
