import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/viewmodel/store/order/order_viewmodel.dart';
import 'package:veloxorder/domain/order/model/order.dart';
import 'package:intl/intl.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  // タブのインデックス
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // タブの数
      initialIndex: 0, // デフォルトで選択するタブ（未調理）
      child: Scaffold(
        appBar: AppBar(
          title: Text('注文管理'),
          bottom: TabBar(
            tabs: [
              Tab(text: '未調理'),
              Tab(text: '調理済み'),
              Tab(text: '提供済み'),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        drawer: CommonDrawer(),
        body: Consumer<OrderViewModel>(
          builder: (context, orderViewModel, child) {
            List<Order> orders = orderViewModel.orders;

            // 現在のタブに応じて注文をフィルタリング
            OrderStatus status;
            switch (_currentIndex) {
              case 0:
                status = OrderStatus.pending;
                break;
              case 1:
                status = OrderStatus.prepared;
                break;
              case 2:
                status = OrderStatus.delivered;
                break;
              default:
                status = OrderStatus.pending;
            }

            List<Order> filteredOrders =
                orders.where((order) => order.status == status).toList();

            if (filteredOrders.isEmpty) {
              return Center(child: Text('注文はありません'));
            }

            return ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                Order order = filteredOrders[index];
                String formattedDate =
                    DateFormat('yyyy/MM/dd HH:mm:ss').format(order.dateTime);
                return ListTile(
                  title: Text('引換券番号: ${order.voucherNumber}'),
                  subtitle: Text('日時: $formattedDate'),
                  trailing: PopupMenuButton<OrderStatus>(
                    onSelected: (value) {
                      setState(() {
                        order.status = value;
                        Provider.of<OrderViewModel>(context, listen: false)
                            .updateOrder(order);
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      List<OrderStatus> options = [];
                      if (order.status == OrderStatus.pending) {
                        options = [OrderStatus.prepared, OrderStatus.delivered];
                      } else if (order.status == OrderStatus.prepared) {
                        options = [OrderStatus.pending, OrderStatus.delivered];
                      } else if (order.status == OrderStatus.delivered) {
                        options = [OrderStatus.pending];
                      }
                      return options.map((OrderStatus choice) {
                        return PopupMenuItem<OrderStatus>(
                          value: choice,
                          child: Text(_getStatusText(choice)),
                        );
                      }).toList();
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/transactionRegistration');
          },
          child: Icon(Icons.add),
          tooltip: '取引登録',
        ),
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return '未調理';
      case OrderStatus.prepared:
        return '調理済み';
      case OrderStatus.delivered:
        return '提供済み';
      default:
        return '';
    }
  }
}
