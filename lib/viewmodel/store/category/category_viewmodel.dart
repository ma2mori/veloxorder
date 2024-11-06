import 'package:flutter/material.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/category/usecase/get_categories_usecase.dart';
import 'package:veloxorder/domain/category/usecase/add_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/update_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/delete_category_usecase.dart';

class CategoryViewModel extends ChangeNotifier {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  List<MenuCategory> categories = [];

  CategoryViewModel({
    required GetCategoriesUseCase getCategoriesUseCase,
    required AddCategoryUseCase addCategoryUseCase,
    required UpdateCategoryUseCase updateCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getCategoriesUseCase = getCategoriesUseCase,
        _addCategoryUseCase = addCategoryUseCase,
        _updateCategoryUseCase = updateCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase {
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
