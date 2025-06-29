import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class GetOrderByIdUsecase implements UseCaseWithParams<Map<String, dynamic>, String> {
  final IPaymentRepository _paymentRepository;

  GetOrderByIdUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String orderId) {
    return _paymentRepository.getOrderById(orderId);
  }
} 