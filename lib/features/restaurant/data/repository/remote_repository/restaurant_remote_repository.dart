import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/data/data_source/remote_datasource/restaurant_remote_datasource.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/repository/restaurant_repository.dart';

class RestaurantRemoteRepository implements IRestaurantRepository {
  final RestaurantRemoteDatasource _restaurantRemoteDatasource;

  RestaurantRemoteRepository({
    required RestaurantRemoteDatasource restaurantRemoteDatasource,
  }) : _restaurantRemoteDatasource = restaurantRemoteDatasource;

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
    try {
      final restaurants = await _restaurantRemoteDatasource.getAllRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveRestaurants(List<RestaurantEntity> restaurants) async {
    try {
      await _restaurantRemoteDatasource.saveRestaurants(restaurants);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearRestaurants() async {
    try {
      await _restaurantRemoteDatasource.clearRestaurants();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}
