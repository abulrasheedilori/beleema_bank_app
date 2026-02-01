import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/provider/auth_repository_provider.dart';
import '../usecases/login_usecase.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return LoginUseCase(repo);
});
