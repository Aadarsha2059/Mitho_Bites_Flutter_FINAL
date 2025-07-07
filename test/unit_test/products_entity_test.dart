import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/food_products/domain/entity/products_entity.dart';

void main() {
  group('ProductsEntity', () {
    test('Can create with required fields', () {
      final product = ProductsEntity(
        name: 'Pizza',
        price: 250.0,
        type: 'Veg',
        description: 'Delicious pizza',
        image: 'pizza.png',
        isAvailable: true,
      );
      expect(product.name, 'Pizza');
      expect(product.price, 250.0);
      expect(product.type, 'Veg');
      expect(product.description, 'Delicious pizza');
      expect(product.image, 'pizza.png');
      expect(product.isAvailable, true);
    });

    test('Can create with all fields', () {
      final product = ProductsEntity(
        productId: '1',
        name: 'Burger',
        price: 150.0,
        type: 'Non-Veg',
        description: 'Juicy burger',
        image: 'burger.png',
        restaurantId: 'r1',
        categoryId: 'c1',
        isAvailable: false,
        categoryName: 'Fast Food',
        categoryImage: 'cat.png',
        restaurantName: 'Foodies',
        restaurantImage: 'rest.png',
        restaurantLocation: 'Kathmandu',
        restaurantContact: '1234567890',
      );
      expect(product.productId, '1');
      expect(product.restaurantId, 'r1');
      expect(product.categoryId, 'c1');
      expect(product.categoryName, 'Fast Food');
      expect(product.categoryImage, 'cat.png');
      expect(product.restaurantName, 'Foodies');
      expect(product.restaurantImage, 'rest.png');
      expect(product.restaurantLocation, 'Kathmandu');
      expect(product.restaurantContact, '1234567890');
      expect(product.isAvailable, false);
    });
  });
} 