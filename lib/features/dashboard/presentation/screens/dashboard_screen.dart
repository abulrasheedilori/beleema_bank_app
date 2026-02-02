import 'package:beleema_bank_app/core/widgets/reuseable_alert_widget.dart';
import 'package:beleema_bank_app/features/dashboard/presentation/widgets/balance_skeleton.dart';
import 'package:beleema_bank_app/features/dashboard/presentation/widgets/transaction_skeleton_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/main_bottom_navigation.dart';
import '../notifier/dashboard_notifier_provider.dart';
import '../widgets/dashboard_components.dart';
import '../widgets/shortcuts_row.dart';
import '../widgets/transactions_list.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);

    if (state.loading) {
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

    if (state.error != null) {
      return Scaffold(
        body: AlertMessage(
          message: state.error ?? "Something went wrong, try again later",
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => notifier.loadDashboard(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  DashboardTopSection(
                    account: state.account!,
                    hideBalance: state.hideBalance,
                    onToggleBalance: notifier.toggleBalanceVisibility,
                  ),

                  Positioned(
                    bottom: -60,
                    left: 0,
                    right: 0,
                    child: const ShortcutsRow(),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: TransactionsHeader()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: TransactionsList(transactions: state.transactions),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            notifier.loadDashboard();
          } else {
            // TODO: handle other navigation
          }
        },
      ),
    );
  }
}
