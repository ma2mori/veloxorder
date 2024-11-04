import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/data/models/menu_category.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/viewmodel/store/menu_viewmodel.dart';
import 'package:veloxorder/data/models/menu_item.dart';

class MenuRegistrationScreen extends StatefulWidget {
  @override
  _MenuRegistrationScreenState createState() => _MenuRegistrationScreenState();
}

class _MenuRegistrationScreenState extends State<MenuRegistrationScreen> {
  MenuCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー登録'),
      ),
      drawer: CommonDrawer(),
      body: Consumer<MenuViewModel>(
        builder: (context, menuViewModel, child) {
          return Row(
            children: [
              // 左側: カテゴリ一覧
              Container(
                width: 150,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        itemCount: menuViewModel.menuCategories.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey),
                        itemBuilder: (context, index) {
                          var category = menuViewModel.menuCategories[index];
                          bool isSelected = selectedCategory == category;
                          return ListTile(
                            title: Text(
                              category.category,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                            selected: isSelected,
                            tileColor:
                                isSelected ? Colors.blue[50] : Colors.white,
                            dense: true,
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey),
                  ],
                ),
              ),
              VerticalDivider(width: 1),
              // 右側: メニューアイテム一覧
              Expanded(
                child: selectedCategory == null
                    ? Center(child: Text('カテゴリを選択してください'))
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${selectedCategory!.category}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add, size: 24),
                                  onPressed: () {
                                    _showAddMenuItemDialog(context);
                                  },
                                  tooltip: 'メニュー追加',
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              itemCount: selectedCategory!.items.length,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1, color: Colors.grey),
                              itemBuilder: (context, index) {
                                var item = selectedCategory!.items[index];
                                return ListTile(
                                  title: Text(
                                    item.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '価格: ¥${item.price}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dense: true,
                                  trailing: _buildActionButtons(
                                    onEdit: () {
                                      _showEditMenuItemDialog(
                                          context, selectedCategory!, item);
                                    },
                                    onDelete: () {
                                      _showDeleteMenuItemDialog(
                                          context, selectedCategory!, item);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(
      {required VoidCallback onEdit, required VoidCallback onDelete}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.edit, size: 20),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: onEdit,
          tooltip: '編集',
        ),
        IconButton(
          icon: Icon(Icons.delete, size: 20),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: onDelete,
          tooltip: '削除',
        ),
      ],
    );
  }

  // メニューアイテム追加ダイアログ
  void _showAddMenuItemDialog(BuildContext context) {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('カテゴリを選択してください'),
        ),
      );
      return;
    }

    final _formKey = GlobalKey<FormState>();
    String? itemName;
    int? itemPrice;
    String? itemNotes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                        .addMenuItem(selectedCategory!.category, newItem);
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

  // メニューアイテム編集ダイアログ
  void _showEditMenuItemDialog(
      BuildContext context, MenuCategory category, MenuItem item) {
    final _formKey = GlobalKey<FormState>();
    String? itemName = item.name;
    int? itemPrice = item.price;
    String? itemNotes = item.notes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('メニューアイテム編集'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: itemName,
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
                    initialValue: itemPrice.toString(),
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
                    initialValue: itemNotes,
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
              child: Text('保存'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (itemName != null && itemPrice != null) {
                    Provider.of<MenuViewModel>(context, listen: false)
                        .updateMenuItem(item, itemName!, itemPrice!,
                            item.imagePath, itemNotes);
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

  // メニューアイテム削除確認ダイアログ
  void _showDeleteMenuItemDialog(
      BuildContext context, MenuCategory category, MenuItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
      },
    );
  }
}
