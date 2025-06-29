import 'package:fooddelivery_b/app/constant/hive_table_constant.dart';
import 'package:fooddelivery_b/core/network/hive_service.dart';
import 'package:fooddelivery_b/features/payment/data/data_source/payment_datasource.dart';
import 'package:fooddelivery_b/features/payment/data/model/payment_hive_model.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';

import 'package:hive_flutter/hive_flutter.dart';

class PaymentLocalDatasource implements IPaymentDataSource {
  final HiveService _hiveService;

  PaymentLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    // Local datasource doesn't handle API calls
    throw UnimplementedError("createOrder not implemented in local datasource");
  }

  @override
  Future<List<Map<String, dynamic>>> getUserOrders() async {
    // Local datasource doesn't handle API calls
    throw UnimplementedError("getUserOrders not implemented in local datasource");
  }

  @override
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    // Local datasource doesn't handle API calls
    throw UnimplementedError("getOrderById not implemented in local datasource");
  }

  @override
  Future<Map<String, dynamic>> updatePaymentStatus(String orderId, String paymentStatus) async {
    // Local datasource doesn't handle API calls
    throw UnimplementedError("updatePaymentStatus not implemented in local datasource");
  }

  @override
  Future<PaymentMethodEntity> createPaymentRecord(PaymentMethodEntity paymentRecord) async {
    try {
      var box = await Hive.openBox<PaymentHiveModel>(HiveTableConstant.paymentBox);
      final hiveModel = PaymentHiveModel.fromEntity(paymentRecord);
      await box.put(hiveModel.id, hiveModel);
      return hiveModel.toEntity();
    } catch (e) {
      throw Exception("Failed to create payment record: $e");
    }
  }

  @override
  Future<List<PaymentMethodEntity>> getAllPaymentRecords() async {
    try {
      var box = await Hive.openBox<PaymentHiveModel>(HiveTableConstant.paymentBox);
      return box.values.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Failed to get payment records: $e");
    }
  }

  @override
  Future<void> savePaymentRecords(List<PaymentMethodEntity> paymentRecords) async {
    try {
      var box = await Hive.openBox<PaymentHiveModel>(HiveTableConstant.paymentBox);
      await box.clear(); // Clear existing data
      for (var paymentRecord in paymentRecords) {
        final hiveModel = PaymentHiveModel.fromEntity(paymentRecord);
        await box.put(hiveModel.id, hiveModel);
      }
    } catch (e) {
      throw Exception("Failed to save payment records: $e");
    }
  }

  @override
  Future<void> clearPaymentRecords() async {
    try {
      var box = await Hive.openBox<PaymentHiveModel>(HiveTableConstant.paymentBox);
      await box.clear();
    } catch (e) {
      throw Exception("Failed to clear payment records: $e");
    }
  }
}