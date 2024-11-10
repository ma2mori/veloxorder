import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/view/store/category/category_registration_screen.dart';
import 'package:veloxorder/view/store/order/order_management_screen.dart';
import 'package:veloxorder/view/store/transaction/transaction_registration_screen.dart';
import 'package:veloxorder/view/store/transaction/transaction_history_screen.dart';
import 'package:veloxorder/view/store/menu/menu_registration_screen.dart';
import 'package:veloxorder/viewmodel/store/category/category_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/transaction/transaction_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/order/order_viewmodel.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firestoreインスタンスの取得
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // テスト用のデータを書き込む
  await firestore
      .collection('test')
      .doc('testDoc')
      .set({'testField': 'testValue'});

  // テスト用のドキュメントを取得
  var testDoc = await firestore.collection('test').doc('testDoc').get();

  print('Firestoreから取得したデータ: ${testDoc.data()}');

  await setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<MenuViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<CategoryViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<TransactionViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<OrderViewModel>(),
        ),
      ],
      child: VeloxOrderApp(),
    ),
  );
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
        '/transactionHistory': (context) => TransactionHistoryScreen(),
        '/menuRegistration': (context) => MenuRegistrationScreen(),
        '/categoryRegistration': (context) => CategoryRegistrationScreen(),
      },
    );
  }
}
