import 'package:flutter/material.dart';
import 'package:fooddelivery_b/features/cart/domain/repository/cart_repository.dart';
import 'package:fooddelivery_b/features/cart/presentation/state/cart_state.dart';
import 'package:fooddelivery_b/features/cart/presentation/event/cart_event.dart';

class CartViewModel extends ChangeNotifier {
  final ICartRepository repository;
  CartState _state = CartInitial();
  CartState get state => _state;

  CartViewModel({required this.repository});

  Future<void> onEvent(CartEvent event) async {
    if (event is LoadCart) {
      _state = CartLoading();
      notifyListeners();
      final result = await repository.getCart();
      result.fold(
        (failure) {
          _state = CartError(failure.message ?? 'Failed to load cart');
          notifyListeners();
        },
        (cart) {
          _state = CartLoaded(cart);
          notifyListeners();
        },
      );
    } else if (event is AddToCart) {
      final result = await repository.addToCart(event.cartItem);
      result.fold(
        (failure) {
          _state = CartError(failure.message ?? 'Failed to add item to cart');
          notifyListeners();
        },
        (_) {
          // Reload cart after adding item
          onEvent(LoadCart());
        },
      );
    } else if (event is UpdateCartItem) {
      final result = await repository.updateCartItem(event.cartItemId, event.quantity);
      result.fold(
        (failure) {
          _state = CartError(failure.message ?? 'Failed to update cart item');
          notifyListeners();
        },
        (_) {
          // Reload cart after updating item
          onEvent(LoadCart());
        },
      );
    } else if (event is RemoveFromCart) {
      final result = await repository.removeFromCart(event.cartItemId);
      result.fold(
        (failure) {
          _state = CartError(failure.message ?? 'Failed to remove item from cart');
          notifyListeners();
        },
        (_) {
          // Reload cart after removing item
          onEvent(LoadCart());
        },
      );
    } else if (event is ClearCart) {
      final result = await repository.clearCart();
      result.fold(
        (failure) {
          _state = CartError(failure.message ?? 'Failed to clear cart');
          notifyListeners();
        },
        (_) {
          // Reload cart after clearing
          onEvent(LoadCart());
        },
      );
    }
  }
} 