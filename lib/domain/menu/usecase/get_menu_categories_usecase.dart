import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

class GetMenuCategoriesUseCase {
  final MenuRepository repository;

  GetMenuCategoriesUseCase(this.repository);

  Future<List<MenuCategory>> call() async {
    return await repository.getMenuCategories();
  }
}
