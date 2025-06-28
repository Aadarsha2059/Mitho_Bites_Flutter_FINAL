import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class RemoveFromCartUsecase implements UseCaseWithParams<void, String> {
  final ICartRepository _cartRepository;

  RemoveFromCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(String cartItemId) {
    return _cartRepository.removeFromCart(cartItemId);
  }
}