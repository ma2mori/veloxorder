import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuRepositoryImpl implements MenuRepository {
  final Box<MenuItem> _menuItemBox = getIt<Box<MenuItem>>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MenuRepositoryImpl();

  @override
  Future<List<MenuItem>> getMenuItems() async {
    // Firebase からデータを取得し、ローカルに保存
    var snapshot = await _firestore.collection('menuItems').get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      MenuItem item = MenuItem(
        id: doc.id,
        name: data['name'],
        price: data['price'],
        categoryId: data['categoryId'],
        notes: data['notes'],
        imagePath: data['imagePath'],
      );
      // ローカルに保存（キーは Hive の自動生成キーを使用）
      await _menuItemBox.put(item.key, item);
    }

    return _menuItemBox.values.toList();
  }

  @override
  Future<void> addMenuItem(MenuItem item) async {
    // Firebase に追加
    DocumentReference docRef = await _firestore.collection('menuItems').add({
      'name': item.name,
      'price': item.price,
      'categoryId': item.categoryId,
      'notes': item.notes,
      'imagePath': item.imagePath,
    });
    item.id = docRef.id;

    // ローカルに保存
    await _menuItemBox.add(item);
  }

  @override
  Future<void> updateMenuItem(MenuItem item) async {
    // Firebase を更新
    if (item.id != null) {
      await _firestore.collection('menuItems').doc(item.id).update({
        'name': item.name,
        'price': item.price,
        'categoryId': item.categoryId,
        'notes': item.notes,
        'imagePath': item.imagePath,
      });
    }

    // ローカルを更新
    await item.save();
  }

  @override
  Future<void> deleteMenuItem(MenuItem item) async {
    // Firebase から削除
    if (item.id != null) {
      await _firestore.collection('menuItems').doc(item.id).delete();
    }

    // ローカルから削除
    await item.delete();
  }
}
