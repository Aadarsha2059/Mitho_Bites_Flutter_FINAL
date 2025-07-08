import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:fooddelivery_b/features/restaurant/domain/entity/restaurant_entity.dart';
import 'package:fooddelivery_b/features/restaurant/domain/use_case/get_restaurants_usecase.dart';
import 'package:fooddelivery_b/core/error/failure.dart';
import 'repository.mock.dart';

void main() {
  late MockRestaurantRepository mockRepository;
  late GetRestaurantsUsecase usecase;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    usecase = GetRestaurantsUsecase(restaurantRepository: mockRepository);
  });

  final tRestaurants = [
    RestaurantEntity(
      restaurantId: '1',
      name: 'Testaurant',
      contact: '1234567890',
      location: 'Kathmandu',
      image: 'test.png',
    ),
    RestaurantEntity(
      restaurantId: '2',
      name: 'Food Place',
      contact: '0987654321',
      location: 'Lalitpur',
      image: 'food.png',
    ),
  ];

  test('should return list of restaurants on success', () async {
    when(() => mockRepository.getRestaurants())
        .thenAnswer((_) async => Right(tRestaurants));

    final result = await usecase();

    expect(result, Right(tRestaurants));
    verify(() => mockRepository.getRestaurants()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure on error', () async {
    when(() => mockRepository.getRestaurants())
        .thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'error')));

    final result = await usecase();

    expect(result, isA<Left<Failure, List<RestaurantEntity>>>());
    verify(() => mockRepository.getRestaurants()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}