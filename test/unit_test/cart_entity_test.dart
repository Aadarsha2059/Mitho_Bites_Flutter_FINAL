import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_entity.dart';
import 'package:fooddelivery_b/features/cart/domain/entity/cart_item_entity.dart';

void main() {
  group('CartEntity', () {
    test('totalAmount, itemCount, uniqueItemCount, isEmpty', () {
      final cart = CartEntity(
        cartId: 'cart1',
        userId: 'user1',
        items: [
          CartItemEntity(
            productId: 'p1',
            productName: 'Pizza',
            productPrice: 250.0,
            quantity: 2,
            price: 250.0,
          ),
          CartItemEntity(
            productId: 'p2',
            productName: 'Burger',
            productPrice: 150.0,
            quantity: 1,
            price: 150.0,
          ),
        ],
      );
      expect(cart.totalAmount, 650.0);
      expect(cart.itemCount, 3);
      expect(cart.uniqueItemCount, 2);
      expect(cart.isEmpty, false);
    });

    test('getItemByProductId returns correct item or null', () {
      final cart = CartEntity(
        items: [
          CartItemEntity(
            productId: 'p1',
            productName: 'Pizza',
            productPrice: 250.0,
            quantity: 2,
            price: 250.0,
          ),
        ],
      );
      expect(cart.getItemByProductId('p1')?.productName, 'Pizza');
      expect(cart.getItemByProductId('p2'), isNull);
    });

    test('toOrderMap returns correct map', () {
      final cart = CartEntity(
        items: [
          CartItemEntity(
            productId: 'p1',
            productName: 'Pizza',
            productPrice: 250.0,
            quantity: 2,
            price: 250.0,
          ),
        ],
      );
      final map = cart.toOrderMap(userId: 'user1');
      expect(map['userId'], 'user1');
      expect(map['totalAmount'], 500.0);
      expect(map['items'], isA<List>());
    });

    test('toPaymentMap returns correct map', () {
      final cart = CartEntity(
        items: [
          CartItemEntity(
            productId: 'p1',
            productName: 'Pizza',
            productPrice: 250.0,
            quantity: 2,
            price: 250.0,
          ),
        ],
      );
      final map = cart.toPaymentMap(paymentMode: 'esewa');
      expect(map['food'], 'Pizza');
      expect(map['quantity'], 2);
      expect(map['totalprice'], 500.0);
      expect(map['paymentmode'], 'esewa');
    });

    test('getPaymentSummary returns correct summary', () {
      final cart = CartEntity(
        items: [
          CartItemEntity(
            productId: 'p1',
            productName: 'Pizza',
            productPrice: 250.0,
            quantity: 2,
            price: 250.0,
          ),
        ],
      );
      final summary = cart.getPaymentSummary();
      expect(summary['totalItems'], 2);
      expect(summary['uniqueItems'], 1);
      expect(summary['subtotal'], 500.0);
      expect(summary['deliveryFee'], 50.0);
      expect(summary['totalAmount'], 550.0);
      expect(summary['itemNames'], ['Pizza']);
    });
  });
} 