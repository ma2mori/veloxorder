import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:veloxorder/domain/order/model/order.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrderRemoteDataSource(this._firestore);

  Future<List<Order>> fetchOrders() async {
    var snapshot = await _firestore.collection('orders').get();

    List<Order> orders = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      List<OrderItem> items = [];

      for (var itemData in data['items']) {
        items.add(OrderItem(
          menuItemId: itemData['menuItemId'],
          quantity: itemData['quantity'],
          status: OrderItemStatus.values[itemData['status']],
        ));
      }

      Order order = Order(
        id: doc.id,
        voucherNumber: data['voucherNumber'],
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        items: items,
      );
      orders.add(order);
    }

    return orders;
  }

  Future<String> addOrder(Order order) async {
    List<Map<String, dynamic>> itemsData = order.items.map((item) {
      return {
        'menuItemId': item.menuItemId,
        'quantity': item.quantity,
        'status': item.status.index,
      };
    }).toList();

    DocumentReference docRef = await _firestore.collection('orders').add({
      'voucherNumber': order.voucherNumber,
      'dateTime': order.dateTime,
      'items': itemsData,
    });
    return docRef.id;
  }

  Future<void> updateOrder(Order order) async {
    if (order.id != null) {
      List<Map<String, dynamic>> itemsData = order.items.map((item) {
        return {
          'menuItemId': item.menuItemId,
          'quantity': item.quantity,
          'status': item.status.index,
        };
      }).toList();

      await _firestore.collection('orders').doc(order.id).update({
        'voucherNumber': order.voucherNumber,
        'dateTime': order.dateTime,
        'items': itemsData,
      });
    }
  }

  Future<void> deleteOrder(Order order) async {
    if (order.id != null) {
      await _firestore.collection('orders').doc(order.id).delete();
    }
  }
}
