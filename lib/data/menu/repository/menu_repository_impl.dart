import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/data/menu/source/remote/menu_remote_data_source.dart';
import 'package:veloxorder/data/menu/source/local/menu_local_data_source.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remoteDataSource;
  final MenuLocalDataSource _localDataSource;

  MenuRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<MenuItem>> getMenuItems() async {
    try {
      // リモートからデータを取得
      List<MenuItem> remoteItems = await _remoteDataSource.fetchMenuItems();

      // ローカルに保存
      await _localDataSource.saveMenuItems(remoteItems);

      return remoteItems;
    } catch (e) {
      // リモートからの取得に失敗した場合、ローカルから取得
      return await _localDataSource.getMenuItems();
    }
  }

  @override
  Future<void> addMenuItem(MenuItem item) async {
    // リモートに追加
    String id = await _remoteDataSource.addMenuItem(item);
    item.id = id;

    // ローカルに追加
    await _localDataSource.addMenuItem(item);
  }

  @override
  Future<void> updateMenuItem(MenuItem item) async {
    // リモートを更新
    await _remoteDataSource.updateMenuItem(item);

    // ローカルを更新
    await _localDataSource.updateMenuItem(item);
  }

  @override
  Future<void> deleteMenuItem(MenuItem item) async {
    // リモートから削除
    await _remoteDataSource.deleteMenuItem(item);

    // ローカルから削除
    await _localDataSource.deleteMenuItem(item);
  }
}
