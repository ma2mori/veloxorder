import 'package:veloxorder/domain/category/model/menu_category.dart';

abstract class CategoryRepository {
  Future<List<MenuCategory>> getCategories();
  Future<void> addCategory(MenuCategory category);
  Future<void> updateCategory(MenuCategory category);
  Future<void> deleteCategory(MenuCategory category);
}
