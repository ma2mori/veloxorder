import 'package:hive/hive.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

class CategoryLocalDataSource {
  final Box<MenuCategory> _categoryBox;

  CategoryLocalDataSource(this._categoryBox);

  Future<List<MenuCategory>> getCategories() async {
    return _categoryBox.values.toList();
  }

  Future<void> saveCategories(List<MenuCategory> categories) async {
    await _categoryBox.clear();
    await _categoryBox.addAll(categories);
  }

  Future<void> addCategory(MenuCategory category) async {
    await _categoryBox.add(category);
  }

  Future<void> updateCategory(MenuCategory category) async {
    await category.save();
  }

  Future<void> deleteCategory(MenuCategory category) async {
    await category.delete();
  }
}
