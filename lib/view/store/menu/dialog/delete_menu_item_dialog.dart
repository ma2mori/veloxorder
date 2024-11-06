import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/viewmodel/store/menu_viewmodel.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

class DeleteMenuItemDialog extends StatelessWidget {
  final MenuCategory category;
  final MenuItem item;

  const DeleteMenuItemDialog({
    Key? key,
    required this.category,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('メニューアイテム削除'),
      content: Text('「${item.name}」を削除しますか？'),
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
            Provider.of<MenuViewModel>(context, listen: false)
                .deleteMenuItem(category, item);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
