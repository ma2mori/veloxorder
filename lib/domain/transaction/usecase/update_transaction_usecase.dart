import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/domain/transaction/repository/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> call(Transaction transaction) async {
    await repository.updateTransaction(transaction);
  }
}
