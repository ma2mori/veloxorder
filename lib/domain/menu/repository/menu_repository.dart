import 'package:veloxorder/domain/menu/model/menu_item.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems();
  Future<void> addMenuItem(MenuItem item);
  Future<void> updateMenuItem(MenuItem item);
  Future<void> deleteMenuItem(MenuItem item);
}
