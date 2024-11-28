import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    final String? baseUrl = dotenv.env['BASE_URL'];
    String qrData = '$baseUrl/#/order?orderId=$orderId';
    print(qrData);

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
