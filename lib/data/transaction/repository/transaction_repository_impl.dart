import 'package:hive/hive.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/domain/transaction/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Box<Transaction> _transactionBox = getIt<Box<Transaction>>();

  @override
  Future<List<Transaction>> getTransactions() async {
    return _transactionBox.values.toList();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.add(transaction);
  }
}
