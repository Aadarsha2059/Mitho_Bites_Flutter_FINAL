import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/entity/payment_entity.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class GetAllPaymentRecordsUsecase implements UsecaseWithoutParams<List<PaymentMethodEntity>> {
  final IPaymentRepository _paymentRepository;

  GetAllPaymentRecordsUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> call() {
    return _paymentRepository.getAllPaymentRecords();
  }
} 