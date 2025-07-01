import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';
import 'package:fooddelivery_b/features/order/domain/repository/order_repository.dart';
import 'package:fooddelivery_b/features/order/data/data_source/order_api_i_datasource.dart';

class OrderRepositoryImpl implements IOrderRepository {
  final IOrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl({required IOrderRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final orders = await _remoteDataSource.getAllOrders();
      return Right(orders);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId) async {
    try {
      final order = await _remoteDataSource.getOrderById(orderId);
      return Right(order);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createOrder(OrderEntity order) async {
    try {
      await _remoteDataSource.createOrder(order);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status) async {
    try {
      await _remoteDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      await _remoteDataSource.updatePaymentStatus(orderId, paymentStatus);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearOrders() async {
    return Left(RemoteDatabaseFailure(message: "Not supported for remote orders"));
  }

  @override
  Future<Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      await _remoteDataSource.cancelOrder(orderId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markOrderReceived(String orderId) async {
    try {
      await _remoteDataSource.markOrderReceived(orderId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}