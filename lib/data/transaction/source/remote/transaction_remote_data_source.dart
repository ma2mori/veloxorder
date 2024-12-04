import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:veloxorder/domain/transaction/model/transaction.dart';

class TransactionRemoteDataSource {
  final FirebaseFirestore _firestore;

  TransactionRemoteDataSource(this._firestore);

  Future<List<Transaction>> fetchTransactions() async {
    var snapshot = await _firestore.collection('transactions').get();

    List<Transaction> transactions = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      Transaction transaction = Transaction(
        id: doc.id,
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        voucherNumber: data['voucherNumber'],
        totalAmount: data['totalAmount'],
        receivedAmount: data['receivedAmount'],
        change: data['change'],
        items: Map<String, dynamic>.from(data['items'])
            .map((key, value) => MapEntry<String, int>(key, value)),
        isDeleted: data['isDeleted'] ?? false,
      );
      transactions.add(transaction);
    }

    return transactions;
  }

  Future<String> addTransaction(Transaction transaction) async {
    DocumentReference docRef = await _firestore.collection('transactions').add({
      'dateTime': transaction.dateTime,
      'voucherNumber': transaction.voucherNumber,
      'totalAmount': transaction.totalAmount,
      'receivedAmount': transaction.receivedAmount,
      'change': transaction.change,
      'items': transaction.items,
      'isDeleted': transaction.isDeleted ?? false,
    });
    return docRef.id;
  }

  Future<void> updateTransaction(Transaction transaction) async {
    if (transaction.id != null) {
      await _firestore.collection('transactions').doc(transaction.id).update({
        'isDeleted': transaction.isDeleted ?? false,
      });
    }
  }
}
