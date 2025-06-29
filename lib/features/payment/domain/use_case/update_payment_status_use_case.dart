import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class UpdatePaymentStatusUsecase implements UseCaseWithParams<Map<String, dynamic>, UpdatePaymentStatusParams> {
  final IPaymentRepository _paymentRepository;

  UpdatePaymentStatusUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(UpdatePaymentStatusParams params) {
    return _paymentRepository.updatePaymentStatus(params.orderId, params.paymentStatus);
  }
}

class UpdatePaymentStatusParams {
  final String orderId;
  final String paymentStatus;

  UpdatePaymentStatusParams({
    required this.orderId,
    required this.paymentStatus,
  });
} 