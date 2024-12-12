import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/viewmodel/customer/order_status_viewmodel.dart';
import 'package:intl/intl.dart';

class OrderStatusScreen extends StatefulWidget {
  final String orderId;

  OrderStatusScreen({required this.orderId});

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool _hasShownDialog = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderStatusViewModel(orderId: widget.orderId),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('注文状況'),
        ),
        body: Consumer<OrderStatusViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (viewModel.hasError) {
              return Center(child: Text('注文が見つかりません'));
            } else if (viewModel.order == null) {
              return Center(child: Text('注文が見つかりません'));
            } else {
              // 状態変化を検知してダイアログを表示
              if (viewModel.isOrderReady && !_hasShownDialog) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showOrderReadyDialog(context);
                  _hasShownDialog = true;
                });
              }

              // 日時のフォーマット
              String formattedDate = DateFormat('yyyy/MM/dd HH:mm:ss')
                  .format(viewModel.order!.dateTime);

              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '引換券番号: ${viewModel.order!.voucherNumber.value}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('注文日時: $formattedDate'),
                    SizedBox(height: 16),
                    Text(
                      '注文内容:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.order!.items.length,
                        itemBuilder: (context, index) {
                          var orderItem = viewModel.order!.items[index];
                          var menuItem =
                              viewModel.getMenuItem(orderItem.menuItemId);

                          String itemName = menuItem?.name ?? '不明な商品';
                          String status =
                              viewModel.getStatusText(orderItem.status);

                          return ListTile(
                            title: Text(itemName),
                            subtitle: Text('ステータス: $status'),
                          );
                        },
                      ),
                    ),
                    if (viewModel.isOrderReady)
                      Text(
                        '注文の準備ができました。カウンターにお越しください。',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showOrderReadyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('注文の準備ができました'),
          content: Text('カウンターにお越しください。'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
