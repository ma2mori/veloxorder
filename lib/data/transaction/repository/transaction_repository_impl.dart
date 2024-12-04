import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/domain/transaction/repository/transaction_repository.dart';
import 'package:veloxorder/data/transaction/source/remote/transaction_remote_data_source.dart';
import 'package:veloxorder/data/transaction/source/local/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionLocalDataSource _localDataSource;

  TransactionRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      // リモートからデータを取得
      List<Transaction> remoteTransactions =
          await _remoteDataSource.fetchTransactions();

      // ローカルに保存
      await _localDataSource.saveTransactions(remoteTransactions);

      return remoteTransactions;
    } catch (e) {
      // リモートからの取得に失敗した場合、ローカルから取得
      return await _localDataSource.getTransactions();
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // リモートに追加
    String id = await _remoteDataSource.addTransaction(transaction);
    transaction.id = id;

    // ローカルに追加
    await _localDataSource.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    // リモートを更新
    await _remoteDataSource.updateTransaction(transaction);

    // ローカルを更新
    await _localDataSource.updateTransaction(transaction);
  }
}
