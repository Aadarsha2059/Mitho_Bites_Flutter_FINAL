import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/order/domain/repository/order_repository.dart';

class ClearOrdersUsecase implements UsecaseWithoutParams<void> {
  final IOrderRepository _orderRepository;

  ClearOrdersUsecase({required IOrderRepository orderRepository})
      : _orderRepository = orderRepository;

  @override
  Future<Either<Failure, void>> call() async {
    return _orderRepository.clearOrders();
  }
} 