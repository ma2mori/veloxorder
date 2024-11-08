import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/order/repository/order_repository.dart';

class UpdateOrderUseCase {
  final OrderRepository repository;

  UpdateOrderUseCase(this.repository);

  Future<void> call(Order order) async {
    await repository.updateOrder(order);
  }
}
