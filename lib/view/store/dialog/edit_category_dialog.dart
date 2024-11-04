import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/data/models/menu_category.dart';
import 'package:veloxorder/viewmodel/store/category_viewmodel.dart';

class EditCategoryDialog extends StatelessWidget {
  final MenuCategory category;

  EditCategoryDialog({required this.category});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? newCategoryName = category.category;

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
  }
}
