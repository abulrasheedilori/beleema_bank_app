import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../auth/data/dto/api_response.dart';
import '../../../domain/usecase/transfer_usecase.dart';

class TransferState {
  final bool loading;
  final String? error;
  final double? amount;
  final String? toAccount;
  final ApiResponse? result;

  const TransferState({
    this.loading = false,
    this.error,
    this.amount,
    this.toAccount,
    this.result,
  });

  TransferState copyWith({
    bool? loading,
    String? error,
    double? amount,
    String? toAccount,
    ApiResponse? result,
  }) {
    return TransferState(
      loading: loading ?? this.loading,
      error: error,
      amount: amount ?? this.amount,
      toAccount: toAccount ?? this.toAccount,
      result: result,
    );
  }
}

class TransferNotifier extends StateNotifier<TransferState> {
  final TransferUsecase usecase;

  TransferNotifier(this.usecase) : super(const TransferState());

  void updateAmount(String value) {
    final parsed = double.tryParse(value);
    state = state.copyWith(amount: parsed, error: null);
  }

  void updateToAccount(String value) {
    state = state.copyWith(toAccount: value.trim(), error: null);
  }

  bool validateInputs() {
    if (state.amount == null || state.amount! <= 0) {
      state = state.copyWith(error: 'Invalid amount');
      return false;
    }
    if (state.toAccount == null || state.toAccount!.isEmpty) {
      state = state.copyWith(error: 'Invalid account');
      return false;
    }
    return true;
  }

  Future<void> executeTransfer(String pin) async {
    state = state.copyWith(loading: true, error: null);

    final response = await usecase.executeTransfer(
      amount: state.amount!.toDouble(),
      toAccount: state.toAccount!,
      pin: pin,
    );

    state = state.copyWith(
      loading: false,
      result: response,
      error: response.success ? null : response.message,
    );
  }

  void clearResult() {
    state = state.copyWith(result: null);
  }
}
