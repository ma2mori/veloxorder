import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/data/category/source/remote/category_remote_data_source.dart';
import 'package:veloxorder/data/category/source/local/category_local_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<MenuCategory>> getCategories() async {
    try {
      // リモートからデータを取得
      List<MenuCategory> remoteCategories =
          await _remoteDataSource.fetchCategories();

      // ローカルに保存
      await _localDataSource.saveCategories(remoteCategories);

      return remoteCategories;
    } catch (e) {
      // リモートからの取得に失敗した場合、ローカルから取得
      return await _localDataSource.getCategories();
    }
  }

  @override
  Future<void> addCategory(MenuCategory category) async {
    // リモートに追加
    String id = await _remoteDataSource.addCategory(category);
    category.id = id;

    // ローカルに追加
    await _localDataSource.addCategory(category);
  }

  @override
  Future<void> updateCategory(MenuCategory category) async {
    // リモートを更新
    await _remoteDataSource.updateCategory(category);

    // ローカルを更新
    await _localDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(MenuCategory category) async {
    // リモートから削除
    await _remoteDataSource.deleteCategory(category);

    // ローカルから削除
    await _localDataSource.deleteCategory(category);
  }
}
