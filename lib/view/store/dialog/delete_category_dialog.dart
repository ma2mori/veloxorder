import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/data/models/menu_category.dart';
import 'package:veloxorder/viewmodel/store/category_viewmodel.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final MenuCategory category;

  DeleteCategoryDialog({required this.category});

  @override
  Widget build(BuildContext context) {
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
  }
}
