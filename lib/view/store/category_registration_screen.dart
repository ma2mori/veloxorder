import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/data/models/menu_category.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
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
    final _formKey = GlobalKey<FormState>();
    String? categoryName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('カテゴリー追加'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(labelText: 'カテゴリー名'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'カテゴリー名を入力してください';
                }
                return null;
              },
              onSaved: (value) {
                categoryName = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('追加'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (categoryName != null) {
                    Provider.of<CategoryViewModel>(context, listen: false)
                        .addCategory(categoryName!);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // カテゴリ編集ダイアログ
  void _showEditCategoryDialog(BuildContext context, MenuCategory category) {
    final _formKey = GlobalKey<FormState>();
    String? newCategoryName = category.category;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('カテゴリー編集'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: category.category,
              decoration: InputDecoration(labelText: 'カテゴリー名'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'カテゴリー名を入力してください';
                }
                return null;
              },
              onSaved: (value) {
                newCategoryName = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('保存'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (newCategoryName != null &&
                      newCategoryName != category.category) {
                    Provider.of<CategoryViewModel>(context, listen: false)
                        .editCategory(category, newCategoryName!);
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // カテゴリ削除確認ダイアログ
  void _showDeleteCategoryDialog(BuildContext context, MenuCategory category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('カテゴリー削除'),
          content: Text(
              '「${category.category}」を削除しますか？\n※カテゴリーにメニューアイテムが存在する場合は削除できません。'),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('削除'),
              onPressed: () {
                try {
                  Provider.of<CategoryViewModel>(context, listen: false)
                      .deleteCategory(category);
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
