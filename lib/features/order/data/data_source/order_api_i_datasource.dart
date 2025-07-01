import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';

abstract interface class IOrderRemoteDataSource {
  Future<List<OrderEntity>> getAllOrders();
  Future<OrderEntity> getOrderById(String orderId);
  Future<void> createOrder(OrderEntity order);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> updatePaymentStatus(String orderId, String paymentStatus);
  Future<void> cancelOrder(String orderId);
  Future<void> markOrderReceived(String orderId);
}