import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';

abstract interface class IRestaurantRepository {
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants();
  Future<Either<Failure, void>> saveRestaurants(
    List<RestaurantEntity> restaurants,
  );
  Future<Either<Failure, void>> clearRestaurants();
}
