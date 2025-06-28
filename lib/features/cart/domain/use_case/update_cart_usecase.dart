import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class UpdateCartItemUsecase implements UseCaseWithParams<void, Map<String, dynamic>> {
  final ICartRepository _cartRepository;

  UpdateCartItemUsecase({required ICartRepository cartRepository})
      : _cartRepository = cartRepository;

  @override
  Future<Either<Failure, void>> call(Map<String, dynamic> params) {
    final String cartItemId = params['cartItemId'];
    final int quantity = params['quantity'];
    return _cartRepository.updateCartItem(cartItemId, quantity);
  }
}