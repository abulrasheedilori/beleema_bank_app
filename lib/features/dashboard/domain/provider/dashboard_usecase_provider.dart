import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/dashboard_repository_provider.dart';
import '../usecase/dashboard_usecase.dart';

final dashboardUsecaseProvider = Provider<DashboardUsecase>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  return DashboardUsecase(repository);
});
