import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';

import 'package:fooddelivery_b/features/cart/data/data_source/local_datasource/cart_local_datasource.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class CartLocalRepository implements ICartRepository {
  final CartLocalDatasource _cartLocalDatasource;

  CartLocalRepository({
    required CartLocalDatasource cartLocalDatasource,
  }) : _cartLocalDatasource = cartLocalDatasource;

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _cartLocalDatasource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await _cartLocalDatasource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCart(CartEntity cart) async {
    try {
      await _cartLocalDatasource.saveCart(cart);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem) async {
    try {
      await _cartLocalDatasource.addToCart(cartItem);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(String cartItemId, int quantity) async {
    try {
      await _cartLocalDatasource.updateCartItem(cartItemId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String cartItemId) async {
    try {
      await _cartLocalDatasource.removeFromCart(cartItemId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItemEntity?>> getCartItem(String cartItemId) async {
    try {
      final cartItem = await _cartLocalDatasource.getCartItem(cartItemId);
      return Right(cartItem);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getAllCartItems() async {
    try {
      final cartItems = await _cartLocalDatasource.getAllCartItems();
      return Right(cartItems);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}