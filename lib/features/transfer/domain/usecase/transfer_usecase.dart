import '../../../auth/data/dto/api_response.dart';
import '../../data/repository/transfer_repository.dart';

class TransferUsecase {
  final TransferRepository repository;

  TransferUsecase(this.repository);

  Future<ApiResponse> executeTransfer({
    required double amount,
    required String toAccount,
    required String pin,
  }) {
    return repository.transfer(amount: amount, toAccount: toAccount, pin: pin);
  }
}
