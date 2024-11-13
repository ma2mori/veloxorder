import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Box<MenuCategory> _categoryBox = getIt<Box<MenuCategory>>();
  final MenuRepository _menuRepository = getIt<MenuRepository>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryRepositoryImpl();

  @override
  Future<List<MenuCategory>> getCategories() async {
    // Firebase からデータを取得し、ローカルに保存
    var snapshot = await _firestore.collection('categories').get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      MenuCategory category = MenuCategory(
        id: doc.id,
        category: data['category'],
      );
      // ローカルに保存
      await _categoryBox.put(category.key, category);
    }

    return _categoryBox.values.toList();
  }

  @override
  Future<void> addCategory(MenuCategory category) async {
    // Firebase に追加
    DocumentReference docRef =
        await _firestore.collection('categories').add({'category': category.category});
    category.id = docRef.id;

    // ローカルに保存
    await _categoryBox.add(category);
  }

  @override
  Future<void> updateCategory(MenuCategory category) async {
    // Firebase を更新
    if (category.id != null) {
      await _firestore.collection('categories').doc(category.id).update({
        'category': category.category,
      });
    }

    // ローカルを更新
    await category.save();
  }

  @override
  Future<void> deleteCategory(MenuCategory category) async {
    // カテゴリーに紐づくメニューアイテムが存在するかチェック
    List<MenuItem> linkedItems = (await _menuRepository.getMenuItems())
        .where((item) => item.categoryId == category.key as int)
        .toList();

    if (linkedItems.isNotEmpty) {
      throw Exception('カテゴリーにメニューアイテムが存在します。削除できません。');
    }

    // Firebase から削除
    if (category.id != null) {
      await _firestore.collection('categories').doc(category.id).delete();
    }

    // ローカルから削除
    await category.delete();
  }
}
