import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class SavePaymentRecordsUsecase implements UseCaseWithParams<void, List<PaymentMethodEntity>> {
  final IPaymentRepository _paymentRepository;

  SavePaymentRecordsUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, void>> call(List<PaymentMethodEntity> paymentRecords) {
    return _paymentRepository.savePaymentRecords(paymentRecords);
  }
} 