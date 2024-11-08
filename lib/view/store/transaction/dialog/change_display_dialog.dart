import 'package:flutter/material.dart';

class ChangeDisplayDialog extends StatelessWidget {
  final int changeAmount;

  const ChangeDisplayDialog({Key? key, required this.changeAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('おつり'),
      content: Text('おつりは ¥$changeAmount です。'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    );
  }
}
