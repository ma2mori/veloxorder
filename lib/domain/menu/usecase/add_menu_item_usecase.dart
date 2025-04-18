import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class AddMenuItemUseCase {
  final MenuRepository repository;

  AddMenuItemUseCase(this.repository);

  Future<void> call(MenuItem item) async {
    await repository.addMenuItem(item);
  }
}
