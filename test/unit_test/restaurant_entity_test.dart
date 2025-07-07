import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';

void main() {
  group('RestaurantEntity', () {
    test('Can create with required fields', () {
      final restaurant = RestaurantEntity(
        name: 'Foodies',
        contact: '1234567890',
        location: 'Kathmandu',
        image: 'foodies.png',
      );
      expect(restaurant.name, 'Foodies');
      expect(restaurant.contact, '1234567890');
      expect(restaurant.location, 'Kathmandu');
      expect(restaurant.image, 'foodies.png');
      expect(restaurant.restaurantId, isNull);
    });

    test('Can create with all fields', () {
      final restaurant = RestaurantEntity(
        restaurantId: 'r1',
        name: 'Bites',
        contact: '9876543210',
        location: 'Pokhara',
        image: 'bites.png',
      );
      expect(restaurant.restaurantId, 'r1');
      expect(restaurant.name, 'Bites');
      expect(restaurant.contact, '9876543210');
      expect(restaurant.location, 'Pokhara');
      expect(restaurant.image, 'bites.png');
    });
  });
} 