import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

abstract interface class ICartDataSource {
  Future<CartEntity> getCart();
  Future<void> saveCart(CartEntity cart);
  Future<void> clearCart();
  Future<void> addToCart(CartItemEntity cartItem);
  Future<void> updateCartItem(String cartItemId, int quantity);
  Future<void> removeFromCart(String cartItemId);
  Future<CartItemEntity?> getCartItem(String cartItemId);
  Future<List<CartItemEntity>> getAllCartItems();
}