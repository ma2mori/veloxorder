import 'package:flutter/material.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/menu/usecase/get_menu_categories_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/add_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/update_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/delete_menu_item_usecase.dart';

class MenuViewModel extends ChangeNotifier {
  final GetMenuCategoriesUseCase _getMenuCategoriesUseCase;
  final AddMenuItemUseCase _addMenuItemUseCase;
  final UpdateMenuItemUseCase _updateMenuItemUseCase;
  final DeleteMenuItemUseCase _deleteMenuItemUseCase;

  List<MenuCategory> menuCategories = [];

  MenuViewModel({
    required GetMenuCategoriesUseCase getMenuCategoriesUseCase,
    required AddMenuItemUseCase addMenuItemUseCase,
    required UpdateMenuItemUseCase updateMenuItemUseCase,
    required DeleteMenuItemUseCase deleteMenuItemUseCase,
  })  : _getMenuCategoriesUseCase = getMenuCategoriesUseCase,
        _addMenuItemUseCase = addMenuItemUseCase,
        _updateMenuItemUseCase = updateMenuItemUseCase,
        _deleteMenuItemUseCase = deleteMenuItemUseCase {
    fetchMenuCategories();
  }

  Future<void> fetchMenuCategories() async {
    menuCategories = await _getMenuCategoriesUseCase();
    notifyListeners();
  }

  Future<void> addMenuItem(String categoryName, MenuItem item) async {
    await _addMenuItemUseCase(categoryName, item);
    await fetchMenuCategories();
  }

  Future<void> updateMenuItem(MenuCategory category, MenuItem item) async {
    await _updateMenuItemUseCase(category, item);
    await fetchMenuCategories();
  }

  Future<void> deleteMenuItem(MenuCategory category, MenuItem item) async {
    await _deleteMenuItemUseCase(category, item);
    await fetchMenuCategories();
  }
}
