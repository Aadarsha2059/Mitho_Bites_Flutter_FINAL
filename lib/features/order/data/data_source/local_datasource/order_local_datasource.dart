import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/order_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderLocalDatasource {
  final HiveService _hiveService;

  OrderLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  Future<List<OrderHiveModel>> getAllOrders() async {
    try {
      var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.orderBox);
      return box.values.toList();
    } catch (e) {
      throw Exception("Failed to get orders: $e");
    }
  }

  Future<void> saveOrders(List<OrderHiveModel> orders) async {
    try {
      var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.orderBox);
      await box.clear(); // Clear existing data
      for (var order in orders) {
        await box.put(order.id, order);
      }
    } catch (e) {
      throw Exception("Failed to save orders: $e");
    }
  }

  Future<void> clearOrders() async {
    try {
      var box = await Hive.openBox<OrderHiveModel>(HiveTableConstant.orderBox);
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear orders: $e");
    }
  }
} 