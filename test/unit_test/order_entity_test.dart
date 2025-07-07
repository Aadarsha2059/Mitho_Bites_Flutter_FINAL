import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/order/domain/entity/order_entity.dart';

void main() {
  group('OrderEntity', () {
    test('Can create and convert toJson', () {
      final now = DateTime.now();
      final order = OrderEntity(
        id: 'o1',
        userId: 'u1',
        items: [
          {'productId': 'p1', 'quantity': 2, 'price': 250.0},
        ],
        totalAmount: 500.0,
        deliveryAddress: {'city': 'Kathmandu'},
        deliveryInstructions: 'Leave at door',
        paymentMethod: 'cash',
        paymentStatus: 'pending',
        orderStatus: 'pending',
        estimatedDeliveryTime: now,
        actualDeliveryTime: null,
        orderDate: now,
        createdAt: now,
        updatedAt: now,
      );
      final json = order.toJson();
      expect(json['_id'], 'o1');
      expect(json['userId'], 'u1');
      expect(json['items'], isA<List>());
      expect(json['totalAmount'], 500.0);
      expect(json['deliveryAddress'], {'city': 'Kathmandu'});
      expect(json['deliveryInstructions'], 'Leave at door');
      expect(json['paymentMethod'], 'cash');
      expect(json['paymentStatus'], 'pending');
      expect(json['orderStatus'], 'pending');
      expect(json['estimatedDeliveryTime'], now.toIso8601String());
      expect(json['actualDeliveryTime'], isNull);
      expect(json['orderDate'], now.toIso8601String());
      expect(json['createdAt'], now.toIso8601String());
      expect(json['updatedAt'], now.toIso8601String());
    });

    test('fromJson creates correct instance', () {
      final now = DateTime.now();
      final json = {
        '_id': 'o1',
        'userId': 'u1',
        'items': [
          {'productId': 'p1', 'quantity': 2, 'price': 250.0},
        ],
        'totalAmount': 500.0,
        'deliveryAddress': {'city': 'Kathmandu'},
        'deliveryInstructions': 'Leave at door',
        'paymentMethod': 'cash',
        'paymentStatus': 'pending',
        'orderStatus': 'pending',
        'estimatedDeliveryTime': now.toIso8601String(),
        'actualDeliveryTime': null,
        'orderDate': now.toIso8601String(),
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };
      final order = OrderEntity.fromJson(json);
      expect(order.id, 'o1');
      expect(order.userId, 'u1');
      expect(order.items, isA<List>());
      expect(order.totalAmount, 500.0);
      expect(order.deliveryAddress, {'city': 'Kathmandu'});
      expect(order.deliveryInstructions, 'Leave at door');
      expect(order.paymentMethod, 'cash');
      expect(order.paymentStatus, 'pending');
      expect(order.orderStatus, 'pending');
      expect(order.estimatedDeliveryTime, isNotNull);
      expect(order.actualDeliveryTime, isNull);
      expect(order.orderDate, isNotNull);
      expect(order.createdAt, isNotNull);
      expect(order.updatedAt, isNotNull);
    });
  });
} 