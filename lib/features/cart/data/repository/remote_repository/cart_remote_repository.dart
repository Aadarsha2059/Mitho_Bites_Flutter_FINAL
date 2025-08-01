import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/data/data_source/remote_datasouce/cart_remote_datasource.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class CartRemoteRepository implements ICartRepository {
  final CartRemoteDatasource _cartRemoteDatasource;

  CartRemoteRepository({
    required CartRemoteDatasource cartRemoteDatasource,
  }) : _cartRemoteDatasource = cartRemoteDatasource;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      print('🌐 CartRemoteRepository: Getting cart from backend...');
      final cart = await _cartRemoteDatasource.getCart();
      print('✅ CartRemoteRepository: Got cart from backend with ${cart.items.length} items');
      return Right(cart);
    } catch (e) {
      print('❌ CartRemoteRepository: Failed to get cart from backend - $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCart(CartEntity cart) async {
    try {
      await _cartRemoteDatasource.saveCart(cart);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await _cartRemoteDatasource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem) async {
    try {
      print('🌐 CartRemoteRepository: Adding item to backend cart - ${cartItem.productName}');
      await _cartRemoteDatasource.addToCart(cartItem);
      print('✅ CartRemoteRepository: Successfully added item to backend cart');
      return const Right(null);
    } catch (e) {
      print('❌ CartRemoteRepository: Failed to add item to backend cart - $e');
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(String cartItemId, int quantity) async {
    try {
      await _cartRemoteDatasource.updateCartItem(cartItemId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String cartItemId) async {
    try {
      await _cartRemoteDatasource.removeFromCart(cartItemId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartItemEntity?>> getCartItem(String cartItemId) async {
    try {
      final cartItem = await _cartRemoteDatasource.getCartItem(cartItemId);
      return Right(cartItem);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getAllCartItems() async {
    try {
      final cartItems = await _cartRemoteDatasource.getAllCartItems();
      return Right(cartItems);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}