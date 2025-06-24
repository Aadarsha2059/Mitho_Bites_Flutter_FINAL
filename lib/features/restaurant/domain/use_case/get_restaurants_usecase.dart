import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/repository/restaurant_repository.dart';

class GetRestaurantsUsecase implements UsecaseWithoutParams<List<RestaurantEntity>> {
  final IRestaurantRepository _restaurantRepository;

  GetRestaurantsUsecase({required IRestaurantRepository restaurantRepository})
    : _restaurantRepository = restaurantRepository;

  @override
  Future<Either<Failure, List<RestaurantEntity>>> call() {
    return _restaurantRepository.getRestaurants();
  }
}
