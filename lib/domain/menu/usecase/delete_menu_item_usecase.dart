import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class DeleteMenuItemUseCase {
  final MenuRepository repository;

  DeleteMenuItemUseCase(this.repository);

  Future<void> call(MenuItem item) async {
    await repository.deleteMenuItem(item);
  }
}
