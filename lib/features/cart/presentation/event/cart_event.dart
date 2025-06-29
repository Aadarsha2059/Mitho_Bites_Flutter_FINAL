import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final CartItemEntity cartItem;
  AddToCart(this.cartItem);
}

class UpdateCartItem extends CartEvent {
  final String cartItemId;
  final int quantity;
  UpdateCartItem(this.cartItemId, this.quantity);
}

class UpdateCartItemQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateCartItemQuantity({required this.productId, required this.quantity});
}

class RemoveFromCart extends CartEvent {
  final String productId;
  RemoveFromCart({required this.productId});
}

class ClearCart extends CartEvent {} 