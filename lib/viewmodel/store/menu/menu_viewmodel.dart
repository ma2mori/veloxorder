import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/menu/usecase/get_menu_items_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/add_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/update_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/delete_menu_item_usecase.dart';

class MenuViewModel extends ChangeNotifier {
  final GetMenuItemsUseCase _getMenuItemsUseCase = getIt<GetMenuItemsUseCase>();
  final AddMenuItemUseCase _addMenuItemUseCase = getIt<AddMenuItemUseCase>();
  final UpdateMenuItemUseCase _updateMenuItemUseCase =
      getIt<UpdateMenuItemUseCase>();
  final DeleteMenuItemUseCase _deleteMenuItemUseCase =
      getIt<DeleteMenuItemUseCase>();

  List<MenuItem> menuItems = [];

  MenuViewModel() {
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    menuItems = await _getMenuItemsUseCase();
    notifyListeners();
  }

  List<MenuItem> getMenuItemsByCategory(String categoryId) {
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

  MenuItem? getMenuItemByKey(int key) {
    return menuItems.firstWhereOrNull((item) => item.key == key);
  }

  MenuItem? getMenuItemById(String id) {
    return menuItems.firstWhereOrNull((item) => item.id == id);
  }
}
