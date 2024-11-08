import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/order/repository/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<Order>> call() async {
    return await repository.getOrders();
  }
}
