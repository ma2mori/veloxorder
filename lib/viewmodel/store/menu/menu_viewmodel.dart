import 'package:flutter/material.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/menu/usecase/get_menu_items_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/add_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/update_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/delete_menu_item_usecase.dart';

class MenuViewModel extends ChangeNotifier {
  final GetMenuItemsUseCase _getMenuItemsUseCase;
  final AddMenuItemUseCase _addMenuItemUseCase;
  final UpdateMenuItemUseCase _updateMenuItemUseCase;
  final DeleteMenuItemUseCase _deleteMenuItemUseCase;

  List<MenuItem> menuItems = [];

  MenuViewModel({
    required GetMenuItemsUseCase getMenuItemsUseCase,
    required AddMenuItemUseCase addMenuItemUseCase,
    required UpdateMenuItemUseCase updateMenuItemUseCase,
    required DeleteMenuItemUseCase deleteMenuItemUseCase,
  })  : _getMenuItemsUseCase = getMenuItemsUseCase,
        _addMenuItemUseCase = addMenuItemUseCase,
        _updateMenuItemUseCase = updateMenuItemUseCase,
        _deleteMenuItemUseCase = deleteMenuItemUseCase {
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    menuItems = await _getMenuItemsUseCase();
    notifyListeners();
  }

  List<MenuItem> getMenuItemsByCategory(int categoryId) {
    return menuItems.where((item) => item.categoryId == categoryId).toList();
  }

  Future<void> addMenuItem(MenuItem item) async {
    await _addMenuItemUseCase(item);
    await fetchMenuItems();
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await _updateMenuItemUseCase(item);
    await fetchMenuItems();
  }

  Future<void> deleteMenuItem(MenuItem item) async {
    await _deleteMenuItemUseCase(item);
    await fetchMenuItems();
  }
}
