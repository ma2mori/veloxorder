import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/view/store/common_drawer.dart';
import 'package:veloxorder/view/store/transaction/dialog/change_display_dialog.dart';
import 'package:veloxorder/view/store/transaction/dialog/received_amount_dialog.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/category/category_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/transaction/transaction_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/order/order_viewmodel.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/shared/vo/amount.dart';
import 'package:veloxorder/domain/shared/vo/voucher_number.dart';

class TransactionRegistrationScreen extends StatefulWidget {
  @override
  _TransactionRegistrationScreenState createState() =>
      _TransactionRegistrationScreenState();
}

class _TransactionRegistrationScreenState
    extends State<TransactionRegistrationScreen> {
  MenuCategory? selectedCategory;
  Map<int, int> selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('取引登録'),
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
                          int categoryQuantity =
                              _getCategoryQuantity(category, menuViewModel);
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    category.category,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                if (categoryQuantity > 0)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '$categoryQuantity',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                              ],
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
                            child: Text(
                              '${selectedCategory!.category}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              itemCount: menuViewModel
                                  .getMenuItemsByCategory(
                                      selectedCategory!.key as int)
                                  .length,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1, color: Colors.grey),
                              itemBuilder: (context, index) {
                                var item = menuViewModel.getMenuItemsByCategory(
                                    selectedCategory!.key as int)[index];
                                int itemQuantity = selectedItems[item.key] ?? 0;
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
                                  onTap: () {
                                    _increaseItemQuantity(item);
                                  },
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          _decreaseItemQuantity(item);
                                        },
                                      ),
                                      Text(
                                        '$itemQuantity',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        onPressed: () {
                                          _increaseItemQuantity(item);
                                        },
                                      ),
                                    ],
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('合計点数: ${_getTotalQuantity()}点'),
              Text('合計金額: ¥${_getTotalPrice()}'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerTransaction,
        label: Text('取引登録'),
        icon: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _increaseItemQuantity(MenuItem item) {
    setState(() {
      selectedItems[item.key as int] =
          (selectedItems[item.key as int] ?? 0) + 1;
    });
  }

  void _decreaseItemQuantity(MenuItem item) {
    setState(() {
      if (selectedItems[item.key as int] != null &&
          selectedItems[item.key as int]! > 0) {
        selectedItems[item.key as int] = selectedItems[item.key as int]! - 1;
        if (selectedItems[item.key as int] == 0) {
          selectedItems.remove(item.key as int);
        }
      }
    });
  }

  int _getItemQuantity(MenuItem item) {
    return selectedItems[item.key as int] ?? 0;
  }

  int _getCategoryQuantity(MenuCategory category, MenuViewModel menuViewModel) {
    int total = 0;
    selectedItems.forEach((itemKey, quantity) {
      var item = menuViewModel.getMenuItemByKey(itemKey);
      if (item != null && item.categoryId == category.key as int) {
        total += quantity;
      }
    });
    return total;
  }

  int _getTotalQuantity() {
    int total = 0;
    selectedItems.values.forEach((quantity) {
      total += quantity;
    });
    return total;
  }

  int _getTotalPrice() {
    int total = 0;
    selectedItems.forEach((itemKey, quantity) {
      // MenuItemを取得
      var item = Provider.of<MenuViewModel>(context, listen: false)
          .getMenuItemByKey(itemKey);
      if (item != null) {
        total += item.price * quantity;
      }
    });
    return total;
  }

  void _registerTransaction() async {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('商品が選択されていません')),
      );
      return;
    }

    int totalAmount = _getTotalPrice();

    int? receivedAmount = await _showReceivedAmountDialog(totalAmount);

    if (receivedAmount == null) {
      // キャンセルされた場合
      return;
    }

    if (receivedAmount < totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('預かり金額が不足しています')),
      );
      return;
    }

    int change = receivedAmount - totalAmount;

    // 取引IDを自動生成（ここではタイムスタンプを使用）
    int transactionId = DateTime.now().millisecondsSinceEpoch;

    // 引換券番号を生成（例: 'V' + 取引IDの下6桁）
    String voucherNumber = 'V${transactionId % 1000000}';

    // Transaction の items を作成
    Map<String, int> transactionItems = {};
    selectedItems.forEach((itemKey, quantity) {
      var menuItem = Provider.of<MenuViewModel>(context, listen: false)
          .getMenuItemByKey(itemKey);
      if (menuItem != null && menuItem.id != null) {
        transactionItems[menuItem.id!] = quantity;
      } else {
        print(
            'Error: MenuItem not found for key $itemKey or menuItem.id is null');
      }
    });

    // 取引データを作成
    Transaction transaction = Transaction(
      id: transactionId.toString(),
      dateTime: DateTime.now(),
      voucherNumber: VoucherNumber(voucherNumber),
      totalAmount: Amount(totalAmount),
      receivedAmount: Amount(receivedAmount),
      change: Amount(change),
      items: transactionItems,
    );

    // 取引データを保存
    await Provider.of<TransactionViewModel>(context, listen: false)
        .addTransaction(transaction);

    // OrderItemのリストを作成
    List<OrderItem> orderItems = [];
    selectedItems.forEach((itemKey, quantity) {
      var menuItem = Provider.of<MenuViewModel>(context, listen: false)
          .getMenuItemByKey(itemKey);
      if (menuItem != null && menuItem.id != null) {
        for (int i = 0; i < quantity; i++) {
          orderItems.add(OrderItem(
            menuItemId: menuItem.id!,
            quantity: 1,
            status: OrderItemStatus.pending, // 初期ステータスは未調理
          ));
        }
      } else {
        print(
            'Error: MenuItem not found for key $itemKey or menuItem.id is null');
      }
    });

    // Orderデータを作成
    Order order = Order(
      id: transactionId.toString(),
      voucherNumber: VoucherNumber(voucherNumber),
      dateTime: DateTime.now(),
      items: orderItems,
    );

    // Orderデータを保存
    await Provider.of<OrderViewModel>(context, listen: false).addOrder(order);

    // 選択された商品をクリア
    setState(() {
      selectedItems.clear();
    });

    // おつりを表示
    await showDialog(
      context: context,
      builder: (context) => ChangeDisplayDialog(
        changeAmount: change,
        orderId: order.id!,
      ),
    );
  }

  Future<int?> _showReceivedAmountDialog(int totalAmount) async {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return ReceivedAmountDialog(totalAmount: totalAmount);
      },
    );
  }
}
