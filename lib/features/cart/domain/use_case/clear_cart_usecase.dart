import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class ClearCartUsecase implements UsecaseWithoutParams<void> {
  final ICartRepository _cartRepository;

  ClearCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _cartRepository.clearCart();
  }
}