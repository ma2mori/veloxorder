import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:veloxorder/data/models/menu_category.dart';
import 'package:veloxorder/data/models/menu_item.dart';

class MenuViewModel extends ChangeNotifier {
  late Box<MenuCategory> _menuBox;

  List<MenuCategory> get menuCategories => _menuBox.values.toList();

  MenuViewModel() {
    _menuBox = Hive.box<MenuCategory>('menuCategories');
  }

  void addMenuItem(String categoryName, MenuItem item) {
    final category = _menuBox.values.firstWhere(
        (cat) => cat.category == categoryName,
        orElse: () => throw Exception('Category not found'));
    category.items.add(item);
    category.save();
    notifyListeners();
  }

  void updateMenuItem(
      MenuItem item, String name, int price, String? imagePath, String? notes) {
    item.name = name;
    item.price = price;
    item.imagePath = imagePath;
    item.notes = notes;
    item.save();
    notifyListeners();
  }

  void deleteMenuItem(MenuCategory category, MenuItem item) {
    category.items.remove(item);
    category.save();
    notifyListeners();
  }
}
