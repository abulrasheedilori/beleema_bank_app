import 'package:beleema_bank_app/core/widgets/reuseable_alert_widget.dart';
import 'package:beleema_bank_app/features/dashboard/data/models/account_model.dart';
import 'package:beleema_bank_app/features/dashboard/data/models/transaction_model.dart';
import 'package:beleema_bank_app/features/dashboard/presentation/widgets/balance_skeleton.dart';
import 'package:beleema_bank_app/features/dashboard/presentation/widgets/transaction_skeleton_tile.dart';
import 'package:flutter/material.dart';

import '../../../../core/navigation/main_bottom_navigation.dart';
import '../../data/dashboard_repository.dart';
import '../widgets/dashboard_components.dart';
import '../widgets/shortcuts_row.dart';
import '../widgets/transactions_list.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _repo = DashboardRepository();

  bool _loading = true;
  bool _hideBalance = false;
  String? _error;

  late AccountModel _account;
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      AccountModel account = await _repo.getAccountDetails();
      List<TransactionModel> transactions = await _repo.getTransactions();

      setState(() {
        _account = account;
        _transactions = transactions;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _reloadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    await _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            BalanceSkeleton(),
            SizedBox(height: 24),
            TransactionSkeletonTile(),
            TransactionSkeletonTile(),
            TransactionSkeletonTile(),
          ],
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: AlertMessage(
          message: _error ?? "Something went wrong, try again later",
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadDashboard,

        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DashboardTopSection(
                account: _account,
                hideBalance: _hideBalance,
                onToggleBalance: () =>
                    setState(() => _hideBalance = !_hideBalance),
              ),
            ),

            const SliverToBoxAdapter(child: ShortcutsRow()),
            const SliverToBoxAdapter(child: TransactionsHeader()),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: TransactionsList(transactions: _transactions),
            ),
          ],
        ),
      ),

      bottomNavigationBar: MainBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            // User tapped dashboard again → refresh
            _reloadDashboard();
          } else {
            // TODO: route switching
          }
        },
      ),
    );
  }
}
