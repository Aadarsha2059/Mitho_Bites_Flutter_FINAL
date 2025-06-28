import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class GetCartItemUsecase implements UseCaseWithParams<CartItemEntity?, String> {
  final ICartRepository _cartRepository;

  GetCartItemUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, CartItemEntity?>> call(String cartItemId) {
    return _cartRepository.getCartItem(cartItemId);
  }
}