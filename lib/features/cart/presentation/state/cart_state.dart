import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItemEntity> cartItems;
  
  const CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;
  
  const CartError(this.message);
}

class CartSuccess extends CartState {
  final String message;
  
  const CartSuccess(this.message);
}

// Legacy state class for backward compatibility
class CartStateLegacy {
  final bool isLoading;
  final List<CartItemEntity> cartItems;
  final String? error;
  final bool isSuccess;

  const CartStateLegacy({
    this.isLoading = false,
    this.cartItems = const [],
    this.error,
    this.isSuccess = false,
  });

  CartStateLegacy copyWith({
    bool? isLoading,
    List<CartItemEntity>? cartItems,
    String? error,
    bool? isSuccess,
  }) {
    return CartStateLegacy(
      isLoading: isLoading ?? this.isLoading,
      cartItems: cartItems ?? this.cartItems,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
} 