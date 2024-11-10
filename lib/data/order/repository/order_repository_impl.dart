import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/order/repository/order_repository.dart';
import 'package:hive/hive.dart';
import 'package:veloxorder/di/locator.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Box<Order> _orderBox = getIt<Box<Order>>();

  @override
  Future<List<Order>> getOrders() async {
    return _orderBox.values.toList();
  }

  @override
  Future<void> addOrder(Order order) async {
    await _orderBox.add(order);
  }

  @override
  Future<void> updateOrder(Order order) async {
    await order.save();
  }

  @override
  Future<void> deleteOrder(Order order) async {
    await order.delete();
  }
}
