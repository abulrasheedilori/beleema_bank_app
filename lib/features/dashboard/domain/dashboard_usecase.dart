import '../data/dashboard_repository.dart';
import '../data/models/account_model.dart';
import '../data/models/transaction_model.dart';

class DashboardUsecase {
  final DashboardRepository repository;

  DashboardUsecase(this.repository);

  Future<AccountModel> getAccount() async {
    final data = await repository.getAccountDetails();
    return data;
  }

  Future<List<TransactionModel>> getTransactions() async {
    final data = await repository.getTransactions();
    return data;
  }
}
