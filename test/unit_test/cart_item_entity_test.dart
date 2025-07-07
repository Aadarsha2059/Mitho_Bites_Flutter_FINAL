import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

void main() {
  group('CartItemEntity', () {
    test('Can create with required fields', () {
      final cartItem = CartItemEntity(
        productId: 'p1',
        productName: 'Pizza',
        productPrice: 250.0,
        quantity: 2,
        price: 250.0,
      );
      expect(cartItem.productId, 'p1');
      expect(cartItem.productName, 'Pizza');
      expect(cartItem.productPrice, 250.0);
      expect(cartItem.quantity, 2);
      expect(cartItem.price, 250.0);
      expect(cartItem.totalPrice, 500.0);
    });

    test('copyWith returns a new instance with updated fields', () {
      final cartItem = CartItemEntity(
        productId: 'p1',
        productName: 'Pizza',
        productPrice: 250.0,
        quantity: 2,
        price: 250.0,
      );
      final updated = cartItem.copyWith(productName: 'Burger', quantity: 3);
      expect(updated.productName, 'Burger');
      expect(updated.quantity, 3);
      expect(updated.productId, 'p1');
    });

    test('toOrderItemMap returns correct map', () {
      final cartItem = CartItemEntity(
        productId: 'p1',
        productName: 'Pizza',
        productPrice: 250.0,
        quantity: 2,
        price: 250.0,
      );
      final map = cartItem.toOrderItemMap();
      expect(map['productId'], 'p1');
      expect(map['quantity'], 2);
      expect(map['price'], 250.0);
      expect(map['productName'], 'Pizza');
    });
  });
} 