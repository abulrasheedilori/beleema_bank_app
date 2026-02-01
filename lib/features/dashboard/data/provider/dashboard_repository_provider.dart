import 'package:beleema_bank_app/features/dashboard/data/repository/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/security/secure_storage_provider.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final dio = ref.read(dioProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return DashboardRepository(dio, secureStorage);
});
