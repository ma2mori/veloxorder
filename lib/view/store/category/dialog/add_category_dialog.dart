import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/viewmodel/store/category_viewmodel.dart';

class AddCategoryDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? categoryName;

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
  }
}
