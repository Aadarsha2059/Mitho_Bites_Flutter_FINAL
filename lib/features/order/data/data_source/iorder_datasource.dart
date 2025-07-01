import 'package:fooddelivery_b/features/payment/domain/entity/order_hive_model.dart';

abstract interface class IOrderDataSource {
  Future<List<OrderHiveModel>> getAllOrders();
  Future<void> saveOrders(List<OrderHiveModel> orders);
  Future<void> clearOrders();
} 