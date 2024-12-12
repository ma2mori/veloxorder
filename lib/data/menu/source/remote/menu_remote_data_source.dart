import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/shared/vo/amount.dart';

class MenuRemoteDataSource {
  final FirebaseFirestore _firestore;

  MenuRemoteDataSource(this._firestore);

  Future<List<MenuItem>> fetchMenuItems() async {
    var snapshot = await _firestore.collection('menuItems').get();

    List<MenuItem> menuItems = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      MenuItem item = MenuItem(
        id: doc.id,
        name: data['name'],
        price: Amount(data['price']),
        categoryId: data['categoryId'],
        notes: data['notes'],
        imagePath: data['imagePath'],
      );
      menuItems.add(item);
    }

    return menuItems;
  }

  Future<String> addMenuItem(MenuItem item) async {
    DocumentReference docRef = await _firestore.collection('menuItems').add({
      'name': item.name,
      'price': item.price.value,
      'categoryId': item.categoryId,
      'notes': item.notes,
      'imagePath': item.imagePath,
    });
    return docRef.id;
  }

  Future<void> updateMenuItem(MenuItem item) async {
    if (item.id != null) {
      await _firestore.collection('menuItems').doc(item.id).update({
        'name': item.name,
        'price': item.price.value,
        'categoryId': item.categoryId,
        'notes': item.notes,
        'imagePath': item.imagePath,
      });
    }
  }

  Future<void> deleteMenuItem(MenuItem item) async {
    if (item.id != null) {
      await _firestore.collection('menuItems').doc(item.id).delete();
    }
  }
}
