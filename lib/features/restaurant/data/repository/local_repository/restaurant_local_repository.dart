import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/data/data_source/local_datasource/restaurannt_local_datasource.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/repository/restaurant_repository.dart';

class RestaurantLocalRepository implements IRestaurantRepository {
  final RestauranntLocalDatasource _restauranntLocalDatasource;

  RestaurantLocalRepository({
    required RestauranntLocalDatasource restaurantLocalDatasource,
  }) : _restauranntLocalDatasource = restaurantLocalDatasource;

  @override
  Future<Either<Failure, void>> clearRestaurants() async {
    try {
      await _restauranntLocalDatasource.clearRestaurants();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
    try {
      final restaurants = await _restauranntLocalDatasource.getAllRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveRestaurants(
    List<RestaurantEntity> restaurants,
  ) async {
    try {
      await _restauranntLocalDatasource.saveRestaurants(restaurants);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
