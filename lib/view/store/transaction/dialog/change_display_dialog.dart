import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ChangeDisplayDialog extends StatelessWidget {
  final int changeAmount;
  final String orderId;

  const ChangeDisplayDialog({
    Key? key,
    required this.changeAmount,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String qrData =
        'https://sample.app/order?orderId=$orderId'; // Todo ドメイnをenvから取得するように修正

    return AlertDialog(
      title: Text('おつりと引換券'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('おつりは ¥$changeAmount です。'),
            SizedBox(height: 16),
            Text('こちらのQRコードをお客様にお渡しください。'),
            SizedBox(height: 16),
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: qrData,
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    );
  }
}
