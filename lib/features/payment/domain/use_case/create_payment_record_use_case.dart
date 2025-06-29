import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';

class CreatePaymentRecordUsecase implements UseCaseWithParams<PaymentMethodEntity, PaymentMethodEntity> {
  final IPaymentRepository _paymentRepository;

  CreatePaymentRecordUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, PaymentMethodEntity>> call(PaymentMethodEntity paymentRecord) {
    return _paymentRepository.createPaymentRecord(paymentRecord);
  }
} 