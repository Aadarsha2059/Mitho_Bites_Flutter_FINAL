import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/app/use_case/usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/domain/repository/restaurant_repository.dart';

class ClearRestaurantsUsecase implements UsecaseWithoutParams<void> {
  final IRestaurantRepository _restaurantRepository;

  ClearRestaurantsUsecase({required IRestaurantRepository restaurantRepository})
    : _restaurantRepository = restaurantRepository;

  @override
  Future<Either<Failure, void>> call() {
    return _restaurantRepository.clearRestaurants();
  }
}
