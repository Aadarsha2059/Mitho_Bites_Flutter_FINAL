import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class GetAllCartItemsUsecase implements UsecaseWithoutParams<List<CartItemEntity>> {
  final ICartRepository _cartRepository;

  GetAllCartItemsUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, List<CartItemEntity>>> call() {
    return _cartRepository.getAllCartItems();
  }
} 