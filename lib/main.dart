import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:veloxorder/di/locator.dart';
import 'package:veloxorder/view/customer/order_status_screen.dart';
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

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name ?? '');
        if (uri.path == '/order') {
          String? orderId = uri.queryParameters['orderId'];
          if (orderId != null) {
            return MaterialPageRoute(
              builder: (context) => OrderStatusScreen(orderId: orderId),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => ErrorScreen(),
            );
          }
        } else {
          // デフォルトの店舗側のホーム画面
          return MaterialPageRoute(
            builder: (context) => OrderManagementScreen(),
          );
        }
      },
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

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '無効なURLです。',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
