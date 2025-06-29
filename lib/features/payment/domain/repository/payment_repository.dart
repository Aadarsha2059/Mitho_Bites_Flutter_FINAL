import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';

import 'package:dartz/dartz.dart';

abstract interface class IPaymentRepository {
  // Main payment operations
  Future<Either<Failure, Map<String, dynamic>>> createOrder(String deliveryInstructions, String paymentMethod);
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserOrders();
  Future<Either<Failure, Map<String, dynamic>>> getOrderById(String orderId);
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(String orderId, String paymentStatus);
  
  // Payment record operations
  Future<Either<Failure, PaymentMethodEntity>> createPaymentRecord(PaymentMethodEntity paymentRecord);
  Future<Either<Failure, List<PaymentMethodEntity>>> getAllPaymentRecords();
  Future<Either<Failure, void>> savePaymentRecords(List<PaymentMethodEntity> paymentRecords);
  Future<Either<Failure, void>> clearPaymentRecords();
}