import 'package:flutter/material.dart';
import 'package:veloxorder/view/store/category/category_registration_screen.dart';
import 'package:veloxorder/view/store/order/order_management_screen.dart';
import 'package:veloxorder/view/store/transaction/transaction_registration_screen.dart';
import 'package:veloxorder/view/store/menu/menu_registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/viewmodel/store/category_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/menu_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive の初期化
  await Hive.initFlutter();

  // アダプターの登録
  Hive.registerAdapter(MenuItemAdapter());
  Hive.registerAdapter(MenuCategoryAdapter());

  // ボックスのオープン
  await Hive.openBox<MenuCategory>('menuCategories');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
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
        '/menuRegistration': (context) => MenuRegistrationScreen(),
        '/categoryRegistration': (context) => CategoryRegistrationScreen(),
      },
    );
  }
}
