import 'package:flutter/material.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/order/usecase/get_orders_usecase.dart';
import 'package:veloxorder/domain/order/usecase/add_order_usecase.dart';
import 'package:veloxorder/domain/order/usecase/update_order_usecase.dart';

class OrderViewModel extends ChangeNotifier {
  final GetOrdersUseCase _getOrdersUseCase = getIt<GetOrdersUseCase>();
  final AddOrderUseCase _addOrderUseCase = getIt<AddOrderUseCase>();
  final UpdateOrderUseCase _updateOrderUseCase = getIt<UpdateOrderUseCase>();

  List<Order> orders = [];

  OrderViewModel() {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = await _getOrdersUseCase();
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    await _addOrderUseCase(order);
    await fetchOrders();
  }

  Future<void> updateOrder(Order order) async {
    await _updateOrderUseCase(order);
    await fetchOrders();
  }
}
