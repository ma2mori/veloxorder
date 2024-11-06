import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class DeleteMenuItemUseCase {
  final MenuRepository repository;

  DeleteMenuItemUseCase(this.repository);

  Future<void> call(MenuCategory category, MenuItem item) async {
    await repository.deleteMenuItem(category, item);
  }
}
