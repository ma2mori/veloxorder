import 'package:veloxorder/domain/order/model/order.dart';
import 'package:veloxorder/domain/order/repository/order_repository.dart';
import 'package:veloxorder/data/order/source/remote/order_remote_data_source.dart';
import 'package:veloxorder/data/order/source/local/order_local_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;
  final OrderLocalDataSource _localDataSource;

  OrderRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Order>> getOrders() async {
    try {
      // リモートからデータを取得
      List<Order> remoteOrders = await _remoteDataSource.fetchOrders();

      // ローカルに保存
      await _localDataSource.saveOrders(remoteOrders);

      return remoteOrders;
    } catch (e) {
      // リモートからの取得に失敗した場合、ローカルから取得
      return await _localDataSource.getOrders();
    }
  }

  @override
  Future<void> addOrder(Order order) async {
    // リモートに追加
    String id = await _remoteDataSource.addOrder(order);
    order.id = id;

    // ローカルに追加
    await _localDataSource.addOrder(order);
  }

  @override
  Future<void> updateOrder(Order order) async {
    // リモートを更新
    await _remoteDataSource.updateOrder(order);

    // ローカルを更新
    await _localDataSource.updateOrder(order);
  }

  @override
  Future<void> deleteOrder(Order order) async {
    // リモートから削除
    await _remoteDataSource.deleteOrder(order);

    // ローカルから削除
    await _localDataSource.deleteOrder(order);
  }
}
