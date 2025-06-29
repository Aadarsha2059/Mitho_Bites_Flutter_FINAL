import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/data/data_source/local_data_source/payment_local_datasource.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';

class PaymentLocalRepository implements IPaymentRepository {
  final PaymentLocalDatasource _paymentLocalDatasource;

  PaymentLocalRepository({
    required PaymentLocalDatasource paymentLocalDatasource,
  }) : _paymentLocalDatasource = paymentLocalDatasource;

  @override
  Future<Either<Failure, Map<String, dynamic>>> createOrder(String deliveryInstructions, String paymentMethod) async {
    // Local repository doesn't handle API operations
    return Left(LocalDatabaseFailure(message: 'createOrder not implemented in local repository'));
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserOrders() async {
    // Local repository doesn't handle API operations
    return Left(LocalDatabaseFailure(message: 'getUserOrders not implemented in local repository'));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrderById(String orderId) async {
    // Local repository doesn't handle API operations
    return Left(LocalDatabaseFailure(message: 'getOrderById not implemented in local repository'));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(String orderId, String paymentStatus) async {
    // Local repository doesn't handle API operations
    return Left(LocalDatabaseFailure(message: 'updatePaymentStatus not implemented in local repository'));
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> createPaymentRecord(PaymentMethodEntity paymentRecord) async {
    try {
      final result = await _paymentLocalDatasource.createPaymentRecord(paymentRecord);
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getAllPaymentRecords() async {
    try {
      final paymentRecords = await _paymentLocalDatasource.getAllPaymentRecords();
      return Right(paymentRecords);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePaymentRecords(List<PaymentMethodEntity> paymentRecords) async {
    try {
      await _paymentLocalDatasource.savePaymentRecords(paymentRecords);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearPaymentRecords() async {
    try {
      await _paymentLocalDatasource.clearPaymentRecords();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}