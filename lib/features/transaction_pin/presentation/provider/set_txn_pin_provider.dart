import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/pin_policy.dart';
import '../../domain/set_transaction_pin_usecases.dart';

class PinState {
  final List<int> pin;
  final List<int> confirmPin;
  final bool loading;
  final bool shake; // Added back
  final String? error;
  final bool isConfirmPhase;
  final bool success;

  const PinState({
    this.pin = const [],
    this.confirmPin = const [],
    this.loading = false,
    this.shake = false, // Added back
    this.error,
    this.isConfirmPhase = false,
    this.success = false,
  });

  PinState copyWith({
    List<int>? pin,
    List<int>? confirmPin,
    bool? loading,
    bool? shake,
    String? error,
    bool? isConfirmPhase,
    bool? success,
  }) => PinState(
    pin: pin ?? this.pin,
    confirmPin: confirmPin ?? this.confirmPin,
    loading: loading ?? this.loading,
    shake: shake ?? this.shake,
    error: error, // If error is null in copyWith, it clears the error
    isConfirmPhase: isConfirmPhase ?? this.isConfirmPhase,
    success: success ?? this.success,
  );
}

class PinNotifier extends StateNotifier<PinState> {
  final SetTransactionPinUsecase usecase;
  PinNotifier(this.usecase) : super(const PinState());

  void addDigit(int digit, BuildContext context) {
    if (state.loading) return;

    final isConfirm = state.isConfirmPhase;
    final list = isConfirm ? state.confirmPin : state.pin;

    if (list.length < PinPolicy.length) {
      final newList = [...list, digit];

      if (!isConfirm) {
        if (newList.length == PinPolicy.length) {
          state = state.copyWith(
            pin: newList,
            isConfirmPhase: true,
            error: null,
          );
        } else {
          state = state.copyWith(pin: newList, error: null);
        }
      } else {
        state = state.copyWith(confirmPin: newList, error: null);
        if (newList.length == PinPolicy.length) {
          submitPin(context); // Auto-trigger
        }
      }
    }
  }

  void removeDigit() {
    final list = state.isConfirmPhase ? state.confirmPin : state.pin;
    if (list.isNotEmpty) {
      final newList = List<int>.from(list)..removeLast();
      state = state.isConfirmPhase
          ? state.copyWith(confirmPin: newList, error: null)
          : state.copyWith(pin: newList, error: null);
    }
  }

  void toggleConfirmPhase() {
    state = state.copyWith(isConfirmPhase: !state.isConfirmPhase, error: null);
  }

  void resetShake() => state = state.copyWith(shake: false);

  Future<void> submitPin(BuildContext context) async {
    state = state.copyWith(error: null, shake: false);

    if (state.pin.join() != state.confirmPin.join()) {
      state = state.copyWith(
        error: 'PINs do not match. Try again.',
        shake: true,
        pin: [],
        confirmPin: [],
        isConfirmPhase: false, // Reset to start
      );
      return;
    }

    try {
      state = state.copyWith(loading: true);
      await usecase.execute(
        pin: state.pin.join(),
        confirmPin: state.confirmPin.join(),
      );

      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        pin: [],
        confirmPin: [],
        isConfirmPhase: false,
        success: false,
      );
      // if (e.toString().contains('401')) return;
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
