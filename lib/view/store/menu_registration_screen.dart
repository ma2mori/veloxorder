import 'package:flutter/material.dart';
import 'package:veloxorder/view/store/common_drawer.dart';

class MenuRegistrationScreen extends StatefulWidget {
  @override
  _MenuRegistrationScreenState createState() => _MenuRegistrationScreenState();
}

class _MenuRegistrationScreenState extends State<MenuRegistrationScreen> {
  // 仮データ
  List<Map<String, dynamic>> menus = [
    {
      'category': '飲み物',
      'items': [
        {'name': 'コーヒー', 'price': 300, 'image': null, 'notes': 'ホットコーヒー'},
        {'name': 'アイスティー', 'price': 350, 'image': null, 'notes': null},
      ],
    },
    {
      'category': '食べ物',
      'items': [
        {'name': 'サンドイッチ', 'price': 500, 'image': null, 'notes': 'チキン'},
        {'name': 'スイーツ', 'price': 400, 'image': null, 'notes': 'チョコレート'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー登録'),
      ),
      drawer: CommonDrawer(),
      body: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (context, index) {
          var category = menus[index];
          return ExpansionTile(
            title: Text(category['category']),
            children:
                (category['items'] as List<Map<String, dynamic>>).map((item) {
              return ListTile(
                title: Text(item['name']),
                subtitle: Text('価格: ¥${item['price']}'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  // Todo 編集機能
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMenuDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'メニュー追加',
      ),
    );
  }

  // メニュー追加ダイアログの仮実装
  void _showAddMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('メニュー追加'),
          content: Text('メニュー追加機能を実装します。'),
          actions: <Widget>[
            TextButton(
              child: Text('閉じる'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
