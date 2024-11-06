import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<MenuCategory>> call() async {
    return await repository.getCategories();
  }
}
