import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/order/domain/repository/order_repository.dart';

class UpdatePaymentStatusUsecase implements UseCaseWithParams<void, UpdatePaymentStatusParams> {
  final IOrderRepository _orderRepository;

  UpdatePaymentStatusUsecase({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, void>> call(UpdatePaymentStatusParams params) {
    return _orderRepository.updatePaymentStatus(params.orderId, params.paymentStatus);
  }
}

class UpdatePaymentStatusParams {
  final String orderId;
  final String paymentStatus;

  UpdatePaymentStatusParams({required this.orderId, required this.paymentStatus});
} 