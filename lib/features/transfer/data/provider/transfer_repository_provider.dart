import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/security/secure_storage_provider.dart';
import '../repository/transfer_repository.dart';

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  final dio = ref.read(dioProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return TransferRepository(dio, secureStorage);
});
