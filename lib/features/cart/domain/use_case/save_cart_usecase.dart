import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class SaveCartUsecase implements UseCaseWithParams<void, CartEntity> {
  final ICartRepository _cartRepository;

  SaveCartUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(CartEntity cart) {
    return _cartRepository.saveCart(cart);
  }
} 