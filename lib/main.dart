import 'package:flutter/material.dart';
import 'package:veloxorder/view/store/order_management_screen.dart';
import 'package:veloxorder/view/store/transaction_registration_screen.dart';
import 'package:veloxorder/view/store/menu_registration_screen.dart';
// Todo import 'package:veloxorder/view/authorization_screen.dart';

void main() {
  runApp(VeloxOrderApp());
}

class VeloxOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VeloxOrder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderManagementScreen(),
      routes: {
        '/orderManagement': (context) => OrderManagementScreen(),
        '/transactionRegistration': (context) =>
            TransactionRegistrationScreen(),
        '/menuRegistration': (context) => MenuRegistrationScreen(),
      },
    );
  }
}
