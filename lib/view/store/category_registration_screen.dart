import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/view/store/dialog/add_category_dialog.dart';
import 'package:veloxorder/view/store/dialog/delete_category_dialog.dart';
import 'package:veloxorder/view/store/dialog/edit_category_dialog.dart';
import 'package:veloxorder/viewmodel/store/category_viewmodel.dart';

class CategoryRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('カテゴリー登録'),
      ),
      drawer: CommonDrawer(),
      body: Consumer<CategoryViewModel>(
        builder: (context, categoryViewModel, child) {
          return ListView.separated(
            padding: EdgeInsets.all(16.0),
            itemCount: categoryViewModel.categories.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var category = categoryViewModel.categories[index];
              return ListTile(
                title: Text(
                  category.category,
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: 20),
                      onPressed: () {
                        _showEditCategoryDialog(context, category);
                      },
                      tooltip: '編集',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20),
                      onPressed: () {
                        _showDeleteCategoryDialog(context, category);
                      },
                      tooltip: '削除',
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddCategoryDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'カテゴリー追加',
      ),
    );
  }

  // カテゴリ追加ダイアログ
  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCategoryDialog();
      },
    );
  }

  // カテゴリ編集ダイアログ
  void _showEditCategoryDialog(BuildContext context, MenuCategory category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditCategoryDialog(category: category);
      },
    );
  }

  // カテゴリ削除確認ダイアログ
  void _showDeleteCategoryDialog(BuildContext context, MenuCategory category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteCategoryDialog(category: category);
      },
    );
  }
}
