import 'package:hive/hive.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class MenuLocalDataSource {
  final Box<MenuItem> _menuItemBox;

  MenuLocalDataSource(this._menuItemBox);

  Future<List<MenuItem>> getMenuItems() async {
    return _menuItemBox.values.toList();
  }

  Future<void> saveMenuItems(List<MenuItem> items) async {
    await _menuItemBox.clear();
    await _menuItemBox.addAll(items);
  }

  Future<void> addMenuItem(MenuItem item) async {
    await _menuItemBox.add(item);
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await item.save();
  }

  Future<void> deleteMenuItem(MenuItem item) async {
    await item.delete();
  }
}
