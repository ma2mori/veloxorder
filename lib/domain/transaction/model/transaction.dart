import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class Transaction extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  String voucherNumber;

  @HiveField(3)
  int totalAmount;

  @HiveField(4)
  int receivedAmount;

  @HiveField(5)
  int change;

  @HiveField(6)
  Map<String, int> items;

  @HiveField(7)
  bool? isDeleted;

  Transaction({
    this.id,
    required this.dateTime,
    required this.voucherNumber,
    required this.totalAmount,
    required this.receivedAmount,
    required this.change,
    required this.items,
    this.isDeleted = false,
  });
}
