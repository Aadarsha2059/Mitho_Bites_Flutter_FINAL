import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/order/domain/repository/order_repository.dart';

class UpdateOrderStatusUsecase implements UseCaseWithParams<void, UpdateOrderStatusParams> {
  final IOrderRepository _orderRepository;

  UpdateOrderStatusUsecase({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, void>> call(UpdateOrderStatusParams params) {
    return _orderRepository.updateOrderStatus(params.orderId, params.status);
  }
}

class UpdateOrderStatusParams {
  final String orderId;
  final String status;

  UpdateOrderStatusParams({required this.orderId, required this.status});
}

class CancelOrderUsecase implements UseCaseWithParams<void, String> {
  final IOrderRepository _orderRepository;
  CancelOrderUsecase({required IOrderRepository orderRepository}) : _orderRepository = orderRepository;
  @override
  Future<Either<Failure, void>> call(String orderId) {
    return _orderRepository.cancelOrder(orderId);
  }
}

class MarkOrderReceivedUsecase implements UseCaseWithParams<void, String> {
  final IOrderRepository _orderRepository;
  MarkOrderReceivedUsecase({required IOrderRepository orderRepository}) : _orderRepository = orderRepository;
  @override
  Future<Either<Failure, void>> call(String orderId) {
    return _orderRepository.markOrderReceived(orderId);
  }
} 