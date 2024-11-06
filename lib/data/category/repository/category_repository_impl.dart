import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:hive/hive.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Box<MenuCategory> _categoryBox;

  CategoryRepositoryImpl(this._categoryBox);

  @override
  Future<List<MenuCategory>> getCategories() async {
    return _categoryBox.values.toList();
  }

  @override
  Future<void> addCategory(MenuCategory category) async {
    await _categoryBox.add(category);
  }

  @override
  Future<void> updateCategory(MenuCategory category) async {
    await category.save();
  }

  @override
  Future<void> deleteCategory(MenuCategory category) async {
    if (category.items.isNotEmpty) {
      throw Exception('カテゴリーにメニューアイテムが存在します。削除できません。');
    }
    await category.delete();
  }
}
