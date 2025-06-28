import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/cart/data/repository/local_repository/cart_local_repository.dart';
import 'package:fooddelivery_b/features/cart/data/repository/remote_repository/cart_remote_repository.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';

class CartRepositoryImpl implements ICartRepository {
  final CartLocalRepository _localRepository;
  final CartRemoteRepository _remoteRepository;

  CartRepositoryImpl({
    required CartLocalRepository localRepository,
    required CartRemoteRepository remoteRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    final localResult = await _localRepository.getCart();
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getCart();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (cart) async {
            await _localRepository.saveCart(cart);
            return Right(cart);
          },
        );
      },
      (localCart) {
        _refreshCartInBackground();
        return Right(localCart);
      },
    );
  }

  @override
  Future<Either<Failure, void>> saveCart(CartEntity cart) async {
    return await _localRepository.saveCart(cart);
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    final localResult = await _localRepository.clearCart();
    return localResult.fold(
      (localFailure) => Left(localFailure),
      (_) async {
        try {
          await _remoteRepository.clearCart();
        } catch (e) {
          // Silent fail - local clear was successful
        }
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity cartItem) async {
    final localResult = await _localRepository.addToCart(cartItem);
    return localResult.fold(
      (localFailure) => Left(localFailure),
      (_) async {
        try {
          await _remoteRepository.addToCart(cartItem);
        } catch (e) {
          // Silent fail - local add was successful
        }
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> updateCartItem(String cartItemId, int quantity) async {
    final localResult = await _localRepository.updateCartItem(cartItemId, quantity);
    return localResult.fold(
      (localFailure) => Left(localFailure),
      (_) async {
        try {
          await _remoteRepository.updateCartItem(cartItemId, quantity);
        } catch (e) {
          // Silent fail - local update was successful
        }
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String cartItemId) async {
    final localResult = await _localRepository.removeFromCart(cartItemId);
    return localResult.fold(
      (localFailure) => Left(localFailure),
      (_) async {
        try {
          await _remoteRepository.removeFromCart(cartItemId);
        } catch (e) {
          // Silent fail - local remove was successful
        }
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, CartItemEntity?>> getCartItem(String cartItemId) async {
    final localResult = await _localRepository.getCartItem(cartItemId);
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getCartItem(cartItemId);
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (cartItem) => Right(cartItem),
        );
      },
      (localCartItem) => Right(localCartItem),
    );
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getAllCartItems() async {
    final localResult = await _localRepository.getAllCartItems();
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getAllCartItems();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (cartItems) async {
            // Save items to local storage
            final cart = CartEntity(
              cartId: null,
              userId: null,
              items: cartItems,
              createdAt: null,
              updatedAt: null,
            );
            await _localRepository.saveCart(cart);
            return Right(cartItems);
          },
        );
      },
      (localCartItems) async {
        if (localCartItems.isEmpty) {
          final remoteResult = await _remoteRepository.getAllCartItems();
          return remoteResult.fold(
            (remoteFailure) => Left(remoteFailure),
            (cartItems) async {
              // Save items to local storage
              final cart = CartEntity(
                cartId: null,
                userId: null,
                items: cartItems,
                createdAt: null,
                updatedAt: null,
              );
              await _localRepository.saveCart(cart);
              return Right(cartItems);
            },
          );
        }
        _refreshCartItemsInBackground();
        return Right(localCartItems);
      },
    );
  }

  void _refreshCartInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getCart();
      remoteResult.fold(
        (failure) {},
        (cart) async {
          await _localRepository.saveCart(cart);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }

  void _refreshCartItemsInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getAllCartItems();
      remoteResult.fold(
        (failure) {},
        (cartItems) async {
          final cart = CartEntity(
            cartId: null,
            userId: null,
            items: cartItems,
            createdAt: null,
            updatedAt: null,
          );
          await _localRepository.saveCart(cart);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }
} 