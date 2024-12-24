import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/view/store/menu/dialog/add_menu_item_dialog.dart';
import 'package:veloxorder/view/store/menu/dialog/delete_menu_item_dialog.dart';
import 'package:veloxorder/view/store/menu/dialog/edit_menu_item_dialog.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/category/category_viewmodel.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';

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
      body: Consumer2<MenuViewModel, CategoryViewModel>(
        builder: (context, menuViewModel, categoryViewModel, child) {
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
                        itemCount: categoryViewModel.categories.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey),
                        itemBuilder: (context, index) {
                          var category = categoryViewModel.categories[index];
                          bool isSelected = selectedCategory == category;
                          return ListTile(
                            title: Text(
                              category.category.value,
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
                                    '${selectedCategory!.category.value}',
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
                              itemCount: menuViewModel
                                  .getMenuItemsByCategory(selectedCategory!.id!)
                                  .length,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1, color: Colors.grey),
                              itemBuilder: (context, index) {
                                var items =
                                    menuViewModel.getMenuItemsByCategory(
                                        selectedCategory!.id!);
                                var item = items[index];
                                return ListTile(
                                  title: Text(
                                    item.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    '価格: ¥${item.price.value}',
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMenuItemDialog(category: selectedCategory!);
      },
    );
  }

  // メニューアイテム編集ダイアログ
  void _showEditMenuItemDialog(
      BuildContext context, MenuCategory category, MenuItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditMenuItemDialog(category: category, item: item);
      },
    );
  }

  // メニューアイテム削除確認ダイアログ
  void _showDeleteMenuItemDialog(
      BuildContext context, MenuCategory category, MenuItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteMenuItemDialog(category: category, item: item);
      },
    );
  }
}
