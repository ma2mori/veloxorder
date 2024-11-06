import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> call(MenuCategory category) async {
    await repository.deleteCategory(category);
  }
}
