import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:hive/hive.dart';

class MenuRepositoryImpl implements MenuRepository {
  final Box<MenuCategory> _menuBox;

  MenuRepositoryImpl(this._menuBox);

  @override
  Future<List<MenuCategory>> getMenuCategories() async {
    return _menuBox.values.toList();
  }

  @override
  Future<void> addMenuItem(String categoryName, MenuItem item) async {
    final category = _menuBox.values.firstWhere(
      (cat) => cat.category == categoryName,
      orElse: () => throw Exception('Category not found'),
    );
    category.items.add(item);
    await category.save();
  }

  @override
  Future<void> updateMenuItem(MenuCategory category) async {
    await category.save();
  }

  @override
  Future<void> deleteMenuItem(MenuCategory category, MenuItem item) async {
    category.items.remove(item);
    await category.save();
  }
}
