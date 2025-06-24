import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';

abstract interface class IRestaurantDataSource {
  Future<List<RestaurantEntity>> getAllRestaurants();
  Future<void> saveRestaurants(List<RestaurantEntity> restaurants);
  Future<void> clearRestaurants();
}
