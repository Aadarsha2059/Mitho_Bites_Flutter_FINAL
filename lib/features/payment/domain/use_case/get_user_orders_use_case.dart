import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class GetUserOrdersUsecase implements UsecaseWithoutParams<List<Map<String, dynamic>>> {
  final IPaymentRepository _paymentRepository;

  GetUserOrdersUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call() {
    return _paymentRepository.getUserOrders();
  }
} 