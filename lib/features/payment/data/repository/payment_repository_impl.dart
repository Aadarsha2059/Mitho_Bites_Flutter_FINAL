import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/data/repository/payment_local_repository.dart';
import 'package:fooddelivery_b/features/payment/data/repository/payment_remote_repository.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';

class PaymentRepositoryImpl implements IPaymentRepository {
  final PaymentLocalRepository _localRepository;
  final PaymentRemoteRepository _remoteRepository;

  PaymentRepositoryImpl({
    required PaymentLocalRepository localRepository,
    required PaymentRemoteRepository remoteRepository,
  }) : _localRepository = localRepository,
       _remoteRepository = remoteRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> createOrder(String deliveryInstructions, String paymentMethod) async {
    // Create order is always a remote operation
    return await _remoteRepository.createOrder(deliveryInstructions, paymentMethod);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserOrders() async {
    // Try local first, then remote
    final localResult = await _localRepository.getUserOrders();
    
    return localResult.fold(
      (localFailure) async {
        // Local failed, try remote
        final remoteResult = await _remoteRepository.getUserOrders();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (orders) async {
            // Save orders locally for future use
            // Note: This would require converting Map to entities first
            return Right(orders);
          },
        );
      },
      (localOrders) {
        // Local data available, refresh in background
        _refreshOrdersInBackground();
        return Right(localOrders);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrderById(String orderId) async {
    // Try local first, then remote
    final localResult = await _localRepository.getOrderById(orderId);
    
    return localResult.fold(
      (localFailure) async {
        // Local failed, try remote
        final remoteResult = await _remoteRepository.getOrderById(orderId);
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (order) async {
            // Save order locally for future use
            // Note: This would require converting Map to entities first
            return Right(order);
          },
        );
      },
      (localOrder) {
        // Local data available, refresh in background
        _refreshOrderInBackground(orderId);
        return Right(localOrder);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePaymentStatus(String orderId, String paymentStatus) async {
    // Update payment status is always a remote operation
    return await _remoteRepository.updatePaymentStatus(orderId, paymentStatus);
  }

  @override
  Future<Either<Failure, PaymentMethodEntity>> createPaymentRecord(PaymentMethodEntity paymentRecord) async {
    // Create payment record - try remote first, then save locally
    final remoteResult = await _remoteRepository.createPaymentRecord(paymentRecord);
    
    return remoteResult.fold(
      (remoteFailure) => Left(remoteFailure),
      (remoteRecord) async {
        // Remote success, save locally
        final localResult = await _localRepository.createPaymentRecord(remoteRecord);
        return localResult.fold(
          (localFailure) => Right(remoteRecord), // Return remote data even if local save fails
          (localRecord) => Right(remoteRecord),
        );
      },
    );
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getAllPaymentRecords() async {
    // Try local first, then remote
    final localResult = await _localRepository.getAllPaymentRecords();
    
    return localResult.fold(
      (localFailure) async {
        // Local failed, try remote
        final remoteResult = await _remoteRepository.getAllPaymentRecords();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (paymentRecords) async {
            // Save payment records locally
            await _localRepository.savePaymentRecords(paymentRecords);
            return Right(paymentRecords);
          },
        );
      },
      (localPaymentRecords) {
        // Local data available, refresh in background
        _refreshPaymentRecordsInBackground();
        return Right(localPaymentRecords);
      },
    );
  }

  @override
  Future<Either<Failure, void>> savePaymentRecords(List<PaymentMethodEntity> paymentRecords) async {
    // Save payment records locally
    return await _localRepository.savePaymentRecords(paymentRecords);
  }

  @override
  Future<Either<Failure, void>> clearPaymentRecords() async {
    // Clear payment records locally
    return await _localRepository.clearPaymentRecords();
  }

  void _refreshOrdersInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getUserOrders();
      remoteResult.fold(
        (failure) {
          // Silent fail - user still sees local data
        },
        (orders) async {
          // Save orders locally for future use
          // Note: This would require converting Map to entities first
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }

  void _refreshOrderInBackground(String orderId) async {
    try {
      final remoteResult = await _remoteRepository.getOrderById(orderId);
      remoteResult.fold(
        (failure) {
          // Silent fail - user still sees local data
        },
        (order) async {
          // Save order locally for future use
          // Note: This would require converting Map to entities first
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }

  void _refreshPaymentRecordsInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getAllPaymentRecords();
      remoteResult.fold(
        (failure) {
          // Silent fail - user still sees local data
        },
        (paymentRecords) async {
          // Save payment records locally
          await _localRepository.savePaymentRecords(paymentRecords);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }
}