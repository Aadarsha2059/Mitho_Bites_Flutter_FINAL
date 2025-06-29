import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/data/data_source/remote_data_source/payment_remote_datasource.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';

class PaymentRemoteRepository implements IPaymentRepository {
  final PaymentRemoteDataSource _paymentRemoteDataSource;

  PaymentRemoteRepository({
    required PaymentRemoteDataSource paymentRemoteDataSource,
  }) : _paymentRemoteDataSource = paymentRemoteDataSource;

  @override
  Future<Either<Failure, Map<String, dynamic>>> createOrder(String deliveryInstructions, String paymentMethod) async {
    try {
      final orderData = {
        'deliveryInstructions': deliveryInstructions,
        'paymentMethod': paymentMethod,
      };
      final result = await _paymentRemoteDataSource.createOrder(orderData);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserOrders() async {
    try {
      final orders = await _paymentRemoteDataSource.getUserOrders();
      return Right(orders);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrderById(String orderId) async {
    try {
      final order = await _paymentRemoteDataSource.getOrderById(orderId);
      return Right(order);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      final result = await _paymentRemoteDataSource.updatePaymentStatus(orderId, paymentStatus);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> createPaymentRecord(PaymentMethodEntity paymentRecord) async {
    try {
      final result = await _paymentRemoteDataSource.createPaymentRecord(paymentRecord);
      return Right(result);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getAllPaymentRecords() async {
    try {
      final paymentRecords = await _paymentRemoteDataSource.getAllPaymentRecords();
      return Right(paymentRecords);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> savePaymentRecords(List<PaymentMethodEntity> paymentRecords) async {
    try {
      await _paymentRemoteDataSource.savePaymentRecords(paymentRecords);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearPaymentRecords() async {
    try {
      await _paymentRemoteDataSource.clearPaymentRecords();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}