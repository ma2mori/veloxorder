import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String voucherNumber;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  List<OrderItem> items;

  Order({
    this.id,
    required this.voucherNumber,
    required this.dateTime,
    required this.items,
  });
}

@HiveType(typeId: 4)
class OrderItem extends HiveObject {
  @HiveField(0)
  String menuItemId;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  OrderItemStatus status;

  OrderItem({
    required this.menuItemId,
    required this.quantity,
    this.status = OrderItemStatus.pending,
  });
}

@HiveType(typeId: 5)
enum OrderItemStatus {
  @HiveField(0)
  pending, // 未調理

  @HiveField(1)
  prepared, // 調理済み

  @HiveField(2)
  delivered, // 提供済み
}
