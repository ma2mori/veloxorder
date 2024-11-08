import 'package:veloxorder/domain/order/model/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> deleteOrder(Order order);
}
