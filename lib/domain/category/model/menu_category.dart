import 'package:hive/hive.dart';

part 'menu_category.g.dart';

@HiveType(typeId: 1)
class MenuCategory extends HiveObject {
  @HiveField(0)
  String category;

  MenuCategory({
    required this.category,
  });
}
