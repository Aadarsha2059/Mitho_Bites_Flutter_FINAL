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

class RemoveFromCart extends CartEvent {
  final String cartItemId;
  RemoveFromCart(this.cartItemId);
}

class ClearCart extends CartEvent {} 