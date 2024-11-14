import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction hide Order;

// データソース
import 'package:veloxorder/data/menu/source/remote/menu_remote_data_source.dart';
import 'package:veloxorder/data/menu/source/local/menu_local_data_source.dart';

// リポジトリインターフェースと実装
import 'package:veloxorder/domain/menu/repository/menu_repository.dart';
import 'package:veloxorder/data/menu/repository/menu_repository_impl.dart';

import 'package:veloxorder/domain/category/repository/category_repository.dart';
import 'package:veloxorder/data/category/repository/category_repository_impl.dart';

import 'package:veloxorder/domain/transaction/repository/transaction_repository.dart';
import 'package:veloxorder/data/transaction/repository/transaction_repository_impl.dart';

import 'package:veloxorder/domain/order/repository/order_repository.dart';
import 'package:veloxorder/data/order/repository/order_repository_impl.dart';

// ユースケース
import 'package:veloxorder/domain/menu/usecase/add_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/delete_menu_item_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/get_menu_items_usecase.dart';
import 'package:veloxorder/domain/menu/usecase/update_menu_item_usecase.dart';

import 'package:veloxorder/domain/category/usecase/add_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/delete_category_usecase.dart';
import 'package:veloxorder/domain/category/usecase/get_categories_usecase.dart';
import 'package:veloxorder/domain/category/usecase/update_category_usecase.dart';

import 'package:veloxorder/domain/transaction/usecase/add_transaction_usecase.dart';
import 'package:veloxorder/domain/transaction/usecase/get_transactions_usecase.dart';

import 'package:veloxorder/domain/order/usecase/get_orders_usecase.dart';
import 'package:veloxorder/domain/order/usecase/add_order_usecase.dart';
import 'package:veloxorder/domain/order/usecase/update_order_usecase.dart';
import 'package:veloxorder/domain/order/usecase/delete_order_usecase.dart';

// モデル
import 'package:veloxorder/domain/menu/model/menu_item.dart';
import 'package:veloxorder/domain/category/model/menu_category.dart';
import 'package:veloxorder/domain/transaction/model/transaction.dart';
import 'package:veloxorder/domain/order/model/order.dart';

// ViewModel
import 'package:veloxorder/viewmodel/store/menu/menu_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/category/category_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/transaction/transaction_viewmodel.dart';
import 'package:veloxorder/viewmodel/store/order/order_viewmodel.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Hive の初期化
  await Hive.initFlutter();

  // Firebase の初期化
  await Firebase.initializeApp();

  // FirebaseFirestore のインスタンスを取得
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // データソースの登録
  getIt.registerLazySingleton<MenuRemoteDataSource>(
      () => MenuRemoteDataSource(firestore));
  getIt.registerLazySingleton<MenuLocalDataSource>(
      () => MenuLocalDataSource(getIt<Box<MenuItem>>()));

  // アダプターの登録
  Hive.registerAdapter(MenuItemAdapter());
  Hive.registerAdapter(MenuCategoryAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(OrderItemAdapter());
  Hive.registerAdapter(OrderItemStatusAdapter());

  // ボックスのオープン
  final menuItemBox = await Hive.openBox<MenuItem>('menuItems');
  final menuCategoryBox = await Hive.openBox<MenuCategory>('menuCategories');
  final transactionBox = await Hive.openBox<Transaction>('transactions');
  final orderBox = await Hive.openBox<Order>('orders');

  // ボックスの登録
  getIt.registerSingleton<Box<MenuItem>>(menuItemBox);
  getIt.registerSingleton<Box<MenuCategory>>(menuCategoryBox);
  getIt.registerSingleton<Box<Transaction>>(transactionBox);
  getIt.registerSingleton<Box<Order>>(orderBox);

  // リポジトリの登録
  getIt.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(
      getIt<MenuRemoteDataSource>(), getIt<MenuLocalDataSource>()));
  getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl());
  getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl());
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl());

  // ユースケースの登録
  getIt.registerLazySingleton<GetMenuItemsUseCase>(
      () => GetMenuItemsUseCase(getIt<MenuRepository>()));
  getIt.registerLazySingleton<AddMenuItemUseCase>(
      () => AddMenuItemUseCase(getIt<MenuRepository>()));
  getIt.registerLazySingleton<UpdateMenuItemUseCase>(
      () => UpdateMenuItemUseCase(getIt<MenuRepository>()));
  getIt.registerLazySingleton<DeleteMenuItemUseCase>(
      () => DeleteMenuItemUseCase(getIt<MenuRepository>()));

  getIt.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton<AddCategoryUseCase>(
      () => AddCategoryUseCase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton<UpdateCategoryUseCase>(
      () => UpdateCategoryUseCase(getIt<CategoryRepository>()));
  getIt.registerLazySingleton<DeleteCategoryUseCase>(
      () => DeleteCategoryUseCase(getIt<CategoryRepository>()));

  getIt.registerLazySingleton<GetTransactionsUseCase>(
      () => GetTransactionsUseCase(getIt<TransactionRepository>()));
  getIt.registerLazySingleton<AddTransactionUseCase>(
      () => AddTransactionUseCase(getIt<TransactionRepository>()));

  getIt.registerLazySingleton<GetOrdersUseCase>(
      () => GetOrdersUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<AddOrderUseCase>(
      () => AddOrderUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<UpdateOrderUseCase>(
      () => UpdateOrderUseCase(getIt<OrderRepository>()));
  getIt.registerLazySingleton<DeleteOrderUseCase>(
      () => DeleteOrderUseCase(getIt<OrderRepository>()));

  // ViewModelの登録
  getIt.registerLazySingleton<MenuViewModel>(() => MenuViewModel());
  getIt.registerLazySingleton<CategoryViewModel>(() => CategoryViewModel());
  getIt.registerLazySingleton<TransactionViewModel>(
      () => TransactionViewModel());
  getIt.registerLazySingleton<OrderViewModel>(() => OrderViewModel());
}
