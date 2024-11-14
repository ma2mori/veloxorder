import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';

class CategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  CategoryRemoteDataSource(this._firestore);

  Future<List<MenuCategory>> fetchCategories() async {
    var snapshot = await _firestore.collection('categories').get();

    List<MenuCategory> categories = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      MenuCategory category = MenuCategory(
        id: doc.id,
        category: data['category'],
      );
      categories.add(category);
    }

    return categories;
  }

  Future<String> addCategory(MenuCategory category) async {
    DocumentReference docRef = await _firestore.collection('categories').add({
      'category': category.category,
    });
    return docRef.id;
  }

  Future<void> updateCategory(MenuCategory category) async {
    if (category.id != null) {
      await _firestore.collection('categories').doc(category.id).update({
        'category': category.category,
      });
    }
  }

  Future<void> deleteCategory(MenuCategory category) async {
    if (category.id != null) {
      await _firestore.collection('categories').doc(category.id).delete();
    }
  }
}
