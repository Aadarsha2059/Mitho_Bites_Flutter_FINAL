import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';

abstract interface class IOrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);
  Future<Either<Failure, void>> createOrder(OrderEntity order);
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status);
  Future<Either<Failure, void>> updatePaymentStatus(String orderId, String paymentStatus);
  Future<Either<Failure, void>> clearOrders();
  Future<Either<Failure, void>> cancelOrder(String orderId);
  Future<Either<Failure, void>> markOrderReceived(String orderId);
}