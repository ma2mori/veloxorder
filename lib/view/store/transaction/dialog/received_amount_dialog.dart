import 'package:flutter/material.dart';

class ReceivedAmountDialog extends StatelessWidget {
  final int totalAmount;

  const ReceivedAmountDialog({Key? key, required this.totalAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text('預かり金額を入力'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: '合計金額: ¥$totalAmount',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () {
            int? receivedAmount = int.tryParse(controller.text);
            Navigator.of(context).pop(receivedAmount);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
