// domain/set_transaction_pin_usecase.dart
import 'package:beleema_bank_app/features/transaction_pin/domain/pin_policy.dart';

import '../data/pin_repository.dart';

class SetTransactionPinUsecase {
  final PinRepository repository;

  SetTransactionPinUsecase(this.repository);

  Future<void> execute({
    required String pin,
    required String confirmPin,
  }) async {
    if (pin != confirmPin) {
      throw Exception('PINs do not match');
    }
    if (pin.length != PinPolicy.length) {
      throw Exception('PIN must be ${PinPolicy.length} digits');
    }
    await repository.setTransactionPin(pin);
  }
}
