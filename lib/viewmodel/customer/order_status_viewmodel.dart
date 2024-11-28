import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class OrderStatusViewModel extends ChangeNotifier {
  final String orderId;
  Order? order;
  bool isLoading = true;
  bool hasError = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, MenuItem> menuItems = {};

  OrderStatusViewModel({required this.orderId}) {
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    try {
      // Orderを取得
      DocumentSnapshot orderDoc =
          await _firestore.collection('orders').doc(orderId).get();

      if (!orderDoc.exists) {
        hasError = true;
        isLoading = false;
        notifyListeners();
        return;
      }

      var data = orderDoc.data() as Map<String, dynamic>;

      List<OrderItem> items = [];

      for (var itemData in data['items']) {
        items.add(OrderItem(
          menuItemId: itemData['menuItemId'],
          quantity: itemData['quantity'],
          status: OrderItemStatus.values[itemData['status']],
        ));
      }

      order = Order(
        id: orderDoc.id,
        voucherNumber: data['voucherNumber'],
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        items: items,
      );

      // メニューアイテムを取得
      await fetchMenuItems();

      isLoading = false;
      notifyListeners();

      // リアルタイム更新のためのリスナーを設定
      _firestore
          .collection('orders')
          .doc(orderId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          var data = snapshot.data() as Map<String, dynamic>;
          List<OrderItem> items = [];

          for (var itemData in data['items']) {
            items.add(OrderItem(
              menuItemId: itemData['menuItemId'],
              quantity: itemData['quantity'],
              status: OrderItemStatus.values[itemData['status']],
            ));
          }

          order = Order(
            id: snapshot.id,
            voucherNumber: data['voucherNumber'],
            dateTime: (data['dateTime'] as Timestamp).toDate(),
            items: items,
          );

          notifyListeners();
        }
      });
    } catch (e) {
      hasError = true;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMenuItems() async {
    var snapshot = await _firestore.collection('menuItems').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      MenuItem item = MenuItem(
        id: doc.id,
        name: data['name'],
        price: data['price'],
        categoryId: data['categoryId'],
        notes: data['notes'],
        imagePath: data['imagePath'],
      );
      menuItems[doc.id] = item;
    }
  }

  MenuItem? getMenuItem(String menuItemId) {
    return menuItems[menuItemId];
  }

  String getStatusText(OrderItemStatus status) {
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

  bool get isOrderReady {
    // 全てのOrderItemがprepared以上なら、注文の準備ができたとみなす
    return order?.items.every(
            (item) => item.status.index >= OrderItemStatus.prepared.index) ??
        false;
  }
}
