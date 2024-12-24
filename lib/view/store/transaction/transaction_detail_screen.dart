import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/viewmodel/store/transaction/transaction_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  TransactionDetailScreen({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('取引詳細'),
      ),
      body: Consumer<MenuViewModel>(
        builder: (context, menuViewModel, child) {
          String formattedDate =
              DateFormat('yyyy/MM/dd HH:mm:ss').format(transaction.dateTime);

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '取引ID: ${transaction.id}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('日時: $formattedDate'),
                Text('引換券番号: ${transaction.voucherNumber.value}'),
                Text('合計金額: ¥${transaction.totalAmount.value}'),
                SizedBox(height: 16),
                Text(
                  '注文内容:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transaction.items.length,
                    itemBuilder: (context, index) {
                      String menuItemId =
                          transaction.items.keys.elementAt(index);
                      int quantity = transaction.items.values.elementAt(index);
                      var menuItem = menuViewModel.getMenuItemById(menuItemId);

                      return ListTile(
                        title: Text(menuItem?.name ?? '不明な商品'),
                        subtitle: Text('数量: $quantity'),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                if (transaction.isDeleted ?? false)
                  Text(
                    'この取引は取消されました',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, transactionViewModel, child) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: transaction.isDeleted ?? false
                      ? null
                      : () {
                          _showCancelConfirmationDialog(context);
                        },
                  child: Text('取引取消し'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showQRCodeDialog(context);
                  },
                  child: Text('QRコード表示'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('取引取消し'),
          content: Text('この取引を取消しますか？'),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('取消し'),
              onPressed: () {
                Provider.of<TransactionViewModel>(context, listen: false)
                    .deleteTransaction(transaction);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 取引詳細画面を閉じる
              },
            ),
          ],
        );
      },
    );
  }

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRCodeDialog(orderId: transaction.id!);
      },
    );
  }
}

class QRCodeDialog extends StatelessWidget {
  final String orderId;

  QRCodeDialog({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final String? baseUrl = dotenv.env['BASE_URL'];
    String qrData = '$baseUrl/#/order?orderId=$orderId';

    return AlertDialog(
      title: Text('QRコード'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('このQRコードをお客様にお渡しください。'),
          SizedBox(height: 16),
          BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: qrData,
            width: 200,
            height: 200,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('閉じる'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
