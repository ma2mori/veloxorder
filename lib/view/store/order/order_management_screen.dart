import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/viewmodel/store/order/order_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';
import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注文管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '未調理'),
            Tab(text: '調理済み'),
            Tab(text: '提供済み'),
          ],
        ),
      ),
      drawer: CommonDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(OrderItemStatus.pending),
          _buildOrderList(OrderItemStatus.prepared),
          _buildOrderList(OrderItemStatus.delivered),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/transactionRegistration');
        },
        child: Icon(Icons.add),
        tooltip: '取引登録',
      ),
    );
  }

  Widget _buildOrderList(OrderItemStatus status) {
    return Consumer2<OrderViewModel, MenuViewModel>(
      builder: (context, orderViewModel, menuViewModel, child) {
        List<Order> orders = orderViewModel.orders;

        // 全てのOrderItemを抽出し、対応するOrderの情報と紐付ける
        List<_OrderItemWrapper> orderItemList = [];

        for (var order in orders) {
          for (var item in order.items) {
            orderItemList.add(_OrderItemWrapper(
              orderItem: item,
              order: order,
            ));
          }
        }

        // 指定されたステータスに応じてOrderItemをフィルタリング
        List<_OrderItemWrapper> filteredItems = orderItemList
            .where((wrapper) => wrapper.orderItem.status == status)
            .toList();

        // 経過時間が長い順（古い順）に並べ替え
        filteredItems
            .sort((a, b) => a.order.dateTime.compareTo(b.order.dateTime));

        if (filteredItems.isEmpty) {
          return Center(child: Text('注文はありません'));
        }

        return ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            var wrapper = filteredItems[index];
            var orderItem = wrapper.orderItem;
            var order = wrapper.order;

            // 商品名を取得
            MenuItem? menuItem =
                menuViewModel.getMenuItemById(orderItem.menuItemId);
            String itemName = menuItem != null ? menuItem.name : '不明な商品';

            // 経過時間を計算
            Duration elapsedTime = DateTime.now().difference(order.dateTime);
            String elapsedTimeStr = _formatDuration(elapsedTime);

            return ListTile(
              title: Text('引換券番号: ${order.voucherNumber}'),
              subtitle: Text(
                '商品名: $itemName\n経過時間: $elapsedTimeStr',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<OrderItemStatus>(
                onSelected: (value) {
                  setState(() {
                    orderItem.status = value;
                    Provider.of<OrderViewModel>(context, listen: false)
                        .updateOrder(order);
                  });
                },
                itemBuilder: (BuildContext context) {
                  List<OrderItemStatus> options = [];
                  if (orderItem.status == OrderItemStatus.pending) {
                    options = [
                      OrderItemStatus.prepared,
                      OrderItemStatus.delivered
                    ];
                  } else if (orderItem.status == OrderItemStatus.prepared) {
                    options = [
                      OrderItemStatus.pending,
                      OrderItemStatus.delivered
                    ];
                  } else if (orderItem.status == OrderItemStatus.delivered) {
                    options = [OrderItemStatus.pending];
                  }
                  return options.map((OrderItemStatus choice) {
                    return PopupMenuItem<OrderItemStatus>(
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
    );
  }

  String _getStatusText(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.pending:
        return '未調理';
      case OrderItemStatus.prepared:
        return '調理済み';
      case OrderItemStatus.delivered:
        return '提供済み';
      default:
        return '';
    }
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    if (minutes < 1) {
      return '1分未満';
    } else {
      return '$minutes分前';
    }
  }
}

// OrderとOrderItemをまとめるクラス
class _OrderItemWrapper {
  final OrderItem orderItem;
  final Order order;

  _OrderItemWrapper({
    required this.orderItem,
    required this.order,
  });
}
