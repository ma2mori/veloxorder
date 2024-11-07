import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/viewmodel/store/transaction/transaction_viewmodel.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('取引履歴'),
      ),
      drawer: CommonDrawer(),
      body: Consumer<TransactionViewModel>(
        builder: (context, transactionViewModel, child) {
          List<Transaction> transactions = transactionViewModel.transactions;

          if (transactions.isEmpty) {
            return Center(
              child: Text('取引履歴がありません'),
            );
          }

          return ListView.separated(
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              Transaction transaction = transactions[index];
              String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss')
                  .format(transaction.dateTime);
              return ListTile(
                title: Text('取引ID: ${transaction.id}'),
                subtitle: Text(
                    '日時: $formattedDate\n金額: ¥${transaction.totalAmount}\n引換番号: ${transaction.voucherNumber}'),
                isThreeLine: true,
                onTap: () {
                  // TODO: 取引詳細画面へのナビゲーションを実装
                },
              );
            },
          );
        },
      ),
    );
  }
}
