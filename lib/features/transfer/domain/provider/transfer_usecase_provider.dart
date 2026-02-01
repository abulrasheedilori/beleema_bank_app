import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/transfer_repository_provider.dart';
import '../usecase/transfer_usecase.dart';

final transferUseCaseProvider = Provider<TransferUsecase>((ref) {
  final repo = ref.read(transferRepositoryProvider);
  return TransferUsecase(repo);
});
