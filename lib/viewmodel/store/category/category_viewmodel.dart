import 'package:flutter/material.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/category/usecase/get_categories_usecase.dart';
import 'package:veloxorder/domain/category/usecase/add_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/update_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/delete_category_usecase.dart';

class CategoryViewModel extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase =
      getIt<GetCategoriesUseCase>();
  final AddCategoryUseCase _addCategoryUseCase = getIt<AddCategoryUseCase>();
  final UpdateCategoryUseCase _updateCategoryUseCase =
      getIt<UpdateCategoryUseCase>();
  final DeleteCategoryUseCase _deleteCategoryUseCase =
      getIt<DeleteCategoryUseCase>();

  List<MenuCategory> categories = [];

  CategoryViewModel() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    categories = await _getCategoriesUseCase();
    notifyListeners();
  }

  Future<void> addCategory(String categoryName) async {
    final newCategory = MenuCategory(category: categoryName);
    await _addCategoryUseCase(newCategory);
    await fetchCategories();
  }

  Future<void> editCategory(
      MenuCategory category, String newCategoryName) async {
    category.category = newCategoryName;
    await _updateCategoryUseCase(category);
    await fetchCategories();
  }

  Future<void> deleteCategory(MenuCategory category) async {
    await _deleteCategoryUseCase(category);
    await fetchCategories();
  }
}
