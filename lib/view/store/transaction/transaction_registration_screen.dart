import 'package:flutter/material.dart';
import 'package:veloxorder/view/store/common_drawer.dart';

class TransactionRegistrationScreen extends StatefulWidget {
  @override
  _TransactionRegistrationScreenState createState() =>
      _TransactionRegistrationScreenState();
}

class _TransactionRegistrationScreenState
    extends State<TransactionRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('取引登録'),
      ),
      drawer: CommonDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // 注文商品の選択（仮）
            DropdownButton<String>(
              hint: Text('商品を選択'),
              items: <String>['商品A', '商品B', '商品C'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            SizedBox(height: 20),
            // 合計金額の表示（仮）
            Text('合計金額: ¥0'),
            SizedBox(height: 20),
            // 預かり金額の入力
            TextField(
              decoration: InputDecoration(
                labelText: '預かり金額',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            // 会計完了ボタン
            ElevatedButton(
              onPressed: () {
                // Todo 会計完了処理
              },
              child: Text('会計完了'),
            ),
          ],
        ),
      ),
    );
  }
}
