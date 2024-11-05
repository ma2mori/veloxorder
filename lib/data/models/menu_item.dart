import 'package:hive/hive.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 0)
class MenuItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int price;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  String? notes;

  MenuItem({
    required this.name,
    required this.price,
    this.imagePath,
    this.notes,
  });
}
