import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class UpdateMenuItemUseCase {
  final MenuRepository repository;

  UpdateMenuItemUseCase(this.repository);

  Future<void> call(MenuItem item) async {
    await repository.updateMenuItem(item);
  }
}
