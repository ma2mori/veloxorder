import 'package:hive/hive.dart';
import 'package:veloxorder/domain/shared/vo/amount.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 0)
class MenuItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Amount price;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  String? notes;

  @HiveField(4)
  String categoryId;

  @HiveField(5)
  String? id;

  MenuItem({
    required this.name,
    required this.price,
    required this.categoryId,
    this.imagePath,
    this.notes,
    this.id,
  });
}
