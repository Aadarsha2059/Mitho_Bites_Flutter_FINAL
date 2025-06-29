import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class ClearPaymentRecordsUsecase implements UsecaseWithoutParams<void> {
  final IPaymentRepository _paymentRepository;

  ClearPaymentRecordsUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _paymentRepository.clearPaymentRecords();
  }
} 