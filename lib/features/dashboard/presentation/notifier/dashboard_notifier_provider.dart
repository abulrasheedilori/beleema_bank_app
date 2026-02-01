import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/dashboard_repository_provider.dart';
import '../../domain/usecase/dashboard_usecase.dart';
import 'dashboard_notifier.dart';

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      final repository = ref.read(dashboardRepositoryProvider);
      final usecase = DashboardUsecase(repository);
      return DashboardNotifier(usecase);
    });
