import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String voucherNumber;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  Map<int, int> items;

  @HiveField(4)
  OrderStatus status;

  Order({
    required this.id,
    required this.voucherNumber,
    required this.dateTime,
    required this.items,
    this.status = OrderStatus.pending,
  });
}

@HiveType(typeId: 4)
enum OrderStatus {
  @HiveField(0)
  pending, // 未調理

  @HiveField(1)
  prepared, // 調理済み

  @HiveField(2)
  delivered, // 提供済み
}
