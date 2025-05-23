import 'package:flutter/material.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/domain/transaction/usecase/get_transactions_usecase.dart';
import 'package:veloxorder/domain/transaction/usecase/add_transaction_usecase.dart';
import 'package:veloxorder/domain/transaction/usecase/update_transaction_usecase.dart';

class TransactionViewModel extends ChangeNotifier {
  final GetTransactionsUseCase _getTransactionsUseCase =
      getIt<GetTransactionsUseCase>();
  final AddTransactionUseCase _addTransactionUseCase =
      getIt<AddTransactionUseCase>();
  final UpdateTransactionUseCase _updateTransactionUseCase =
      getIt<UpdateTransactionUseCase>();

  List<Transaction> transactions = [];

  TransactionViewModel() {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    transactions = await _getTransactionsUseCase();
    transactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _addTransactionUseCase(transaction);
    await fetchTransactions();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    transaction.isDeleted = true;
    await _updateTransactionUseCase(transaction);
    await fetchTransactions();
  }
}
