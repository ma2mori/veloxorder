import 'package:hive/hive.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';

class TransactionLocalDataSource {
  final Box<Transaction> _transactionBox;

  TransactionLocalDataSource(this._transactionBox);

  Future<List<Transaction>> getTransactions() async {
    return _transactionBox.values.toList();
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    await _transactionBox.clear();
    await _transactionBox.addAll(transactions);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox.add(transaction);
  }
}
