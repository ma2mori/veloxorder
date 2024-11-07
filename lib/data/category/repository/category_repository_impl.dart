import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:hive/hive.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Box<MenuCategory> _categoryBox = getIt<Box<MenuCategory>>();
  final MenuRepository _menuRepository = getIt<MenuRepository>();

  CategoryRepositoryImpl();

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
    // カテゴリーに紐づくメニューアイテムが存在するかチェック
    List<MenuItem> linkedItems = (await _menuRepository.getMenuItems())
        .where((item) => item.categoryId == category.key as int)
        .toList();

    if (linkedItems.isNotEmpty) {
      throw Exception('カテゴリーにメニューアイテムが存在します。削除できません。');
    }

    await category.delete();
  }
}
