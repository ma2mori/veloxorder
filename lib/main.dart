import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:veloxorder/data/category/repository/category_repository_impl.dart';
import 'package:veloxorder/data/menu/repository/menu_repository_impl.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/domain/category/usecase/get_categories_usecase.dart';
import 'package:veloxorder/domain/category/usecase/add_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/update_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/delete_category_usecase.dart';
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/domain/menu/usecase/get_menu_categories_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/add_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/update_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/delete_menu_item_usecase.dart';
import 'package:veloxorder/view/store/category/category_registration_screen.dart';
import 'package:veloxorder/view/store/order/order_management_screen.dart';
import 'package:veloxorder/view/store/transaction/transaction_registration_screen.dart';
import 'package:veloxorder/view/store/menu/menu_registration_screen.dart';
import 'package:veloxorder/viewmodel/store/category/category_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive の初期化
  await Hive.initFlutter();

  // アダプターの登録
  Hive.registerAdapter(MenuItemAdapter());
  Hive.registerAdapter(MenuCategoryAdapter());

  // ボックスのオープン
  final menuCategoryBox = await Hive.openBox<MenuCategory>('menuCategories');

  // リポジトリの初期化
  final menuRepository = MenuRepositoryImpl(menuCategoryBox);
  final categoryRepository = CategoryRepositoryImpl(menuCategoryBox);

  // ユースケースの初期化
  final getMenuCategoriesUseCase = GetMenuCategoriesUseCase(menuRepository);
  final addMenuItemUseCase = AddMenuItemUseCase(menuRepository);
  final updateMenuItemUseCase = UpdateMenuItemUseCase(menuRepository);
  final deleteMenuItemUseCase = DeleteMenuItemUseCase(menuRepository);

  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
  final addCategoryUseCase = AddCategoryUseCase(categoryRepository);
  final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
  final deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuViewModel(
            getMenuCategoriesUseCase: getMenuCategoriesUseCase,
            addMenuItemUseCase: addMenuItemUseCase,
            updateMenuItemUseCase: updateMenuItemUseCase,
            deleteMenuItemUseCase: deleteMenuItemUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryViewModel(
            getCategoriesUseCase: getCategoriesUseCase,
            addCategoryUseCase: addCategoryUseCase,
            updateCategoryUseCase: updateCategoryUseCase,
            deleteCategoryUseCase: deleteCategoryUseCase,
          ),
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
        '/menuRegistration': (context) => MenuRegistrationScreen(),
        '/categoryRegistration': (context) => CategoryRegistrationScreen(),
      },
    );
  }
}
