import 'package:flutter_test/flutter_test.dart';
import 'package:fooddelivery_b/features/food_category/domain/entity/food_category_entity.dart';

void main() {
  group('FoodCategoryEntity', () {
    test('Can create with required fields', () {
      final category = FoodCategoryEntity(
        name: 'Snacks',
        image: 'snacks.png',
      );
      expect(category.name, 'Snacks');
      expect(category.image, 'snacks.png');
      expect(category.categoryId, isNull);
    });

    test('Can create with all fields', () {
      final category = FoodCategoryEntity(
        categoryId: 'c1',
        name: 'Drinks',
        image: 'drinks.png',
      );
      expect(category.categoryId, 'c1');
      expect(category.name, 'Drinks');
      expect(category.image, 'drinks.png');
    });
  });
} 