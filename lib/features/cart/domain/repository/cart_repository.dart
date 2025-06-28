import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

abstract interface class ICartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, void>> saveCart(CartEntity cart);
  Future<Either<Failure, void>> clearCart();
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem);
  Future<Either<Failure, void>> updateCartItem(String cartItemId, int quantity);
  Future<Either<Failure, void>> removeFromCart(String cartItemId);
  Future<Either<Failure, CartItemEntity?>> getCartItem(String cartItemId);
  Future<Either<Failure, List<CartItemEntity>>> getAllCartItems();
}