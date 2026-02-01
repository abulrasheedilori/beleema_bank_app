import 'package:beleema_bank_app/features/transfer/presentation/screens/notifier/transfer_screen_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/provider/transfer_usecase_provider.dart';

final transferNotifierProvider =
    StateNotifierProvider<TransferNotifier, TransferState>((ref) {
      final usecase = ref.read(transferUseCaseProvider);
      return TransferNotifier(usecase);
    });
