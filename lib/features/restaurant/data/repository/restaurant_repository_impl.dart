import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/data/repository/local_repository/restaurant_local_repository.dart';
import 'package:fooddelivery_b/features/restaurant/data/repository/remote_repository/restaurant_remote_repository.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/repository/restaurant_repository.dart';

class RestaurantRepositoryImpl implements IRestaurantRepository {
  final RestaurantLocalRepository _localRepository;
  final RestaurantRemoteRepository _remoteRepository;

  RestaurantRepositoryImpl({
    required RestaurantLocalRepository localRepository,
    required RestaurantRemoteRepository remoteRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
    final localResult = await _localRepository.getRestaurants();
    return localResult.fold(
      (localFailure) async {
        final remoteResult = await _remoteRepository.getRestaurants();
        return remoteResult.fold(
          (remoteFailure) => Left(remoteFailure),
          (restaurants) async {
            await _localRepository.saveRestaurants(restaurants);
            return Right(restaurants);
          },
        );
      },
      (localRestaurants) {
        _refreshRestaurantsInBackground();
        return Right(localRestaurants);
      },
    );
  }

  @override
  Future<Either<Failure, void>> saveRestaurants(List<RestaurantEntity> restaurants) async {
    return await _localRepository.saveRestaurants(restaurants);
  }

  @override
  Future<Either<Failure, void>> clearRestaurants() async {
    return await _localRepository.clearRestaurants();
  }

  void _refreshRestaurantsInBackground() async {
    try {
      final remoteResult = await _remoteRepository.getRestaurants();
      remoteResult.fold(
        (failure) {},
        (restaurants) async {
          await _localRepository.saveRestaurants(restaurants);
        },
      );
    } catch (e) {
      // Silent fail - user still sees local data
    }
  }
}
