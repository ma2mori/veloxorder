import 'package:hive/hive.dart';
import 'package:veloxorder/domain/order/model/order.dart';

class OrderLocalDataSource {
  final Box<Order> _orderBox;

  OrderLocalDataSource(this._orderBox);

  Future<List<Order>> getOrders() async {
    return _orderBox.values.toList();
  }

  Future<void> saveOrders(List<Order> orders) async {
    await _orderBox.clear();
    await _orderBox.addAll(orders);
  }

  Future<void> addOrder(Order order) async {
    await _orderBox.add(order);
  }

  Future<void> updateOrder(Order order) async {
    await order.save();
  }

  Future<void> deleteOrder(Order order) async {
    await order.delete();
  }
}
