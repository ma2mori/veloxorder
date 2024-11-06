import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:hive/hive.dart';

class MenuRepositoryImpl implements MenuRepository {
  final Box<MenuItem> _menuItemBox;

  MenuRepositoryImpl(this._menuItemBox);

  @override
  Future<List<MenuItem>> getMenuItems() async {
    return _menuItemBox.values.toList();
  }

  @override
  Future<void> addMenuItem(MenuItem item) async {
    await _menuItemBox.add(item);
  }

  @override
  Future<void> updateMenuItem(MenuItem item) async {
    await item.save();
  }

  @override
  Future<void> deleteMenuItem(MenuItem item) async {
    await item.delete();
  }
}
