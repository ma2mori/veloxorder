import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

abstract class MenuRepository {
  Future<List<MenuCategory>> getMenuCategories();
  Future<void> addMenuItem(String categoryName, MenuItem item);
  Future<void> updateMenuItem(MenuCategory category);
  Future<void> deleteMenuItem(MenuCategory category, MenuItem item);
}
