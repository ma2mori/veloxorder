import 'package:hive/hive.dart';
import '../../menu/model/menu_item.dart';

part 'menu_category.g.dart';

@HiveType(typeId: 1)
class MenuCategory extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  List<MenuItem> items;

  MenuCategory({
    required this.category,
    required this.items,
  });
}
