import 'package:beleema_bank_app/features/transaction_pin/data/repository/pin_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/security/secure_storage_provider.dart';

final pinRepositoryProvider = Provider<PinRepository>((ref) {
  return PinRepository(
    dio: ref.read(dioProvider),
    secureStorage: ref.read(secureStorageProvider),
  );
});
