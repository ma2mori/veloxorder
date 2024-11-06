import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';

class AddMenuItemDialog extends StatelessWidget {
  final MenuCategory category;

  AddMenuItemDialog({required this.category});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? itemName;
    int? itemPrice;
    String? itemNotes;

    return AlertDialog(
      title: Text('メニューアイテム追加'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '商品名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '商品名を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  itemName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '価格'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '価格を入力してください';
                  }
                  if (int.tryParse(value) == null) {
                    return '有効な価格を入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  itemPrice = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '備考（任意）'),
                onSaved: (value) {
                  itemNotes = value;
                },
              ),
              // Todo 画像アップロード機能は後で実装予定
            ],
          ),
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
              if (itemName != null && itemPrice != null) {
                final newItem = MenuItem(
                  name: itemName!,
                  price: itemPrice!,
                  notes: itemNotes,
                );
                Provider.of<MenuViewModel>(context, listen: false)
                    .addMenuItem(category.category, newItem);
              }
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
