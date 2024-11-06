import 'package:flutter/material.dart';
import 'package:veloxorder/view/store/common_drawer.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  // 仮データ
  List<Map<String, String>> orders = [
    {'id': '1', 'status': '未調理', 'item': '商品A'},
    {'id': '2', 'status': '調理済み', 'item': '商品B'},
    {'id': '3', 'status': '提供済み', 'item': '商品C'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注文管理'),
      ),
      drawer: CommonDrawer(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return ListTile(
            title: Text(order['item']!),
            subtitle: Text('ステータス: ${order['status']}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  order['status'] = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return ['未調理', '調理済み', '提供済み'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
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
    );
  }
}
