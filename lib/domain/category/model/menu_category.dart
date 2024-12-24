import 'package:hive/hive.dart';
import 'package:veloxorder/domain/shared/vo/category_name.dart';

part 'menu_category.g.dart';

@HiveType(typeId: 1)
class MenuCategory extends HiveObject {
  @HiveField(0)
  CategoryName category;

  @HiveField(1)
  String? id;

  MenuCategory({
    required this.category,
    this.id,
  });
}
