import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class AddToCartUsecase implements UseCaseWithParams<void, CartItemEntity> {
  final ICartRepository _cartRepository;

  AddToCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(CartItemEntity cartItem) {
    return _cartRepository.addToCart(cartItem);
  }
}