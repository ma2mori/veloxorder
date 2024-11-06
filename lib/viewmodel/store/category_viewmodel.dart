import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

class CategoryViewModel extends ChangeNotifier {
  late Box<MenuCategory> _categoryBox;

  List<MenuCategory> get categories => _categoryBox.values.toList();

  CategoryViewModel() {
    _categoryBox = Hive.box<MenuCategory>('menuCategories');
  }

  void addCategory(String categoryName) {
    final newCategory = MenuCategory(category: categoryName, items: []);
    _categoryBox.add(newCategory);
    notifyListeners();
  }

  void editCategory(MenuCategory category, String newCategoryName) {
    category.category = newCategoryName;
    category.save();
    notifyListeners();
  }

  void deleteCategory(MenuCategory category) {
    if (category.items.isNotEmpty) {
      throw Exception('カテゴリーにメニューアイテムが存在します。削除できません。');
    }
    category.delete();
    notifyListeners();
  }
}
