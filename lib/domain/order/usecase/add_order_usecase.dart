import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/order/repository/order_repository.dart';

class AddOrderUseCase {
  final OrderRepository repository;

  AddOrderUseCase(this.repository);

  Future<void> call(Order order) async {
    await repository.addOrder(order);
  }
}
