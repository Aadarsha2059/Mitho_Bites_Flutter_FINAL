import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/payment/domain/repository/payment_repository.dart';


class CreateOrderUsecase implements UseCaseWithParams<Map<String, dynamic>, CreateOrderParams> {
  final IPaymentRepository _paymentRepository;

  CreateOrderUsecase({required IPaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(CreateOrderParams params) {
    return _paymentRepository.createOrder(params.deliveryInstructions, params.paymentMethod);
  }

  Future<Either<Failure, Map<String, dynamic>>> execute(Map<String, dynamic> orderData) async {
    final deliveryInstructions = orderData['deliveryInstructions'] ?? '';
    final paymentMethod = orderData['paymentMethod'] ?? '';
    return _paymentRepository.createOrder(deliveryInstructions, paymentMethod);
  }
}

class CreateOrderParams {
  final String deliveryInstructions;
  final String paymentMethod;

  CreateOrderParams({
    required this.deliveryInstructions,
    required this.paymentMethod,
  });
} 