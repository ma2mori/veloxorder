import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'メニュー',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('注文管理'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/orderManagement');
            },
          ),
          ListTile(
            leading: Icon(Icons.add_shopping_cart),
            title: Text('取引登録'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, '/transactionRegistration');
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu),
            title: Text('メニュー登録'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/menuRegistration');
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('カテゴリー登録'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/categoryRegistration');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('ログアウト'),
            onTap: () {
              // Todo ログアウト処理
            },
          ),
        ],
      ),
    );
  }
}
