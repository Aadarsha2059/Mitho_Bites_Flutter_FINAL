import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/get_restaurants_usecase.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/state/restaurant_state.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_event.dart';
import 'package:fooddelivery_b/features/restaurant/presentation/view_model/restaurant_view_model.dart';

class MockGetRestaurantsUsecase extends Mock implements GetRestaurantsUsecase {}

void main() {
  late GetRestaurantsUsecase getRestaurantsUsecase;

  setUp(() {
    getRestaurantsUsecase = MockGetRestaurantsUsecase();
    when(() => getRestaurantsUsecase()).thenAnswer((_) async => const Right(<RestaurantEntity>[]));
  });

  final restaurant1 = RestaurantEntity(
    restaurantId: '1',
    name: 'Food Palace',
    contact: '1234567890',
    location: 'Downtown',
    image: 'assets/images/food_palace.png',
  );
  final restaurant2 = RestaurantEntity(
    restaurantId: '2',
    name: 'Pizza House',
    contact: '0987654321',
    location: 'Uptown',
    image: 'assets/images/pizza_house.png',
  );
  final restaurants = [restaurant1, restaurant2];

  group('RestaurantViewModel', () {
    blocTest<RestaurantViewModel, RestaurantState>(
      'emits [loading, loaded] when LoadRestaurantsEvent succeeds',
      build: () {
        when(() => getRestaurantsUsecase()).thenAnswer((_) async => Right(restaurants));
        return RestaurantViewModel(getRestaurantsUsecase: getRestaurantsUsecase);
      },
      act: (bloc) => bloc.add(const LoadRestaurantsEvent()),
      skip: 2,
      expect: () => [
        RestaurantState.initial().copyWith(restaurants: restaurants, isLoading: true),
        RestaurantState.initial().copyWith(restaurants: restaurants, isLoading: false),
      ],
      verify: (_) {
        verify(() => getRestaurantsUsecase()).called(2);
      },
    );

    blocTest<RestaurantViewModel, RestaurantState>(
      'emits [loading, error] when LoadRestaurantsEvent fails',
      build: () {
        when(() => getRestaurantsUsecase()).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Error')));
        return RestaurantViewModel(getRestaurantsUsecase: getRestaurantsUsecase);
      },
      act: (bloc) => bloc.add(const LoadRestaurantsEvent()),
      skip: 2,
      expect: () => [
        RestaurantState.initial().copyWith(isLoading: true, errorMessage: 'Error'),
        RestaurantState.initial().copyWith(isLoading: false, errorMessage: 'Error'),
      ],
      verify: (_) {
        verify(() => getRestaurantsUsecase()).called(2);
      },
    );

    blocTest<RestaurantViewModel, RestaurantState>(
      'emits [loading, loaded (empty)] when LoadRestaurantsEvent returns empty list',
      build: () {
        when(() => getRestaurantsUsecase()).thenAnswer((_) async => const Right(<RestaurantEntity>[]));
        return RestaurantViewModel(getRestaurantsUsecase: getRestaurantsUsecase);
      },
      act: (bloc) => bloc.add(const LoadRestaurantsEvent()),
      skip: 2,
      expect: () => [
        RestaurantState.initial().copyWith(isLoading: true),
        RestaurantState.initial().copyWith(restaurants: const [], isLoading: false),
      ],
      verify: (_) {
        verify(() => getRestaurantsUsecase()).called(2);
      },
    );
  });
}