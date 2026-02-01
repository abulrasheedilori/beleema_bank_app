import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/account_model.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/usecase/dashboard_usecase.dart';

/// ------------------------
/// Dashboard State
/// ------------------------
class DashboardState {
  final AccountModel? account;
  final List<TransactionModel> transactions;
  final bool loading;
  final String? error;
  final bool hideBalance;

  const DashboardState({
    this.account,
    this.transactions = const [],
    this.loading = true,
    this.error,
    this.hideBalance = false,
  });

  DashboardState copyWith({
    AccountModel? account,
    List<TransactionModel>? transactions,
    bool? loading,
    String? error,
    bool? hideBalance,
  }) => DashboardState(
    account: account ?? this.account,
    transactions: transactions ?? this.transactions,
    loading: loading ?? this.loading,
    error: error,
    hideBalance: hideBalance ?? this.hideBalance,
  );
}

/// ------------------------
/// Dashboard Notifier
/// ------------------------
class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardUsecase usecase;

  DashboardNotifier(this.usecase) : super(const DashboardState(loading: true)) {
    // Automatically load dashboard when notifier is created
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final account = await usecase.getAccount();
      final transactions = await usecase.getTransactions();

      state = state.copyWith(
        account: account,
        transactions: transactions,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  void toggleBalanceVisibility() {
    state = state.copyWith(hideBalance: !state.hideBalance);
  }
}
